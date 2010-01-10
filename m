Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078Ab0AJHpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0AJHpk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 02:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983Ab0AJHpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 02:45:39 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37599 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab0AJHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 02:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=u+f1+8eEcl0A2Omf33V82h/vH11QB9lTGMW+qadYWh3o0DaJInXqVa8/A9osDmZXIc
         SlP9RoTa0GteCy/gVx9bl+UIuVSwdMa+ZKQHhFOGp2ixDNarVOrVrrlMVHJy9rXINMGi
         Y6atWPZoS/BrYPshlelucAi06YIJY7cmv7Ja0=
Date: Sun, 10 Jan 2010 10:45:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [patch] hp-wmi: fix double free
Message-ID: <20100110074529.GF7840@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree(obj) was called earlier.

This was found by smatch and has only been compile tested.  :/

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/platform/x86/hp-wmi.c	2010-01-09 21:43:13.000000000 +0300
+++ devel/drivers/platform/x86/hp-wmi.c	2010-01-09 21:43:28.000000000 +0300
@@ -388,8 +388,6 @@ static void hp_wmi_notify(u32 value, voi
 	} else
 		printk(KERN_INFO "HP WMI: Unknown key pressed - %x\n",
 			eventcode);
-
-	kfree(obj);
 }
 
 static int __init hp_wmi_input_setup(void)
