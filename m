Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYIMJtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYIMJtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 05:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755610AbYIMJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 05:49:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:11248 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYIMJtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 05:49:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=M3hrAAcBAZ/z2J85QiYx8x8S5SNl57igDnAG8YhXIr467WdGVi9Z3rDXlDUz+9BwvW
         1+S/lyXvcHwiB9WHh8zntqeeWtks194EJgTGNkBRJQWnvHh/ogXcIDNdp6hhpf2o1HL9
         17SsTLZVrYp9yjNQ+y7nOf+R+cS/HOfS4tkOc=
Date: Sat, 13 Sep 2008 18:47:19 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Andrey Panin <pazke@donpac.ru>
Subject: [PATCH] ibmasr: remove unnecessary spin_unlock()
Message-ID: <20080913094717.GA3571@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__asr_toggle() is always called with asr_lock held.
But there is unnecessary spin_unlock() call in __asr_toggle().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrey Panin <pazke@donpac.ru>
---
 drivers/watchdog/ibmasr.c |    1 -
 1 file changed, 1 deletion(-)

Index: 2.6-git/drivers/watchdog/ibmasr.c
===================================================================
--- 2.6-git.orig/drivers/watchdog/ibmasr.c
+++ 2.6-git/drivers/watchdog/ibmasr.c
@@ -85,7 +85,6 @@ static void __asr_toggle(void)
 
 	outb(reg & ~asr_toggle_mask, asr_write_addr);
 	reg = inb(asr_read_addr);
-	spin_unlock(&asr_lock);
 }
 
 static void asr_toggle(void)
