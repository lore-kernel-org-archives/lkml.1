Return-Path: <linux-kernel-owner+w=401wt.eu-S1759183AbZDQJTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183AbZDQJTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZDQJTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:19:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:33991 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbZDQJTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:19:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Y8mWotApw7k8oGYOVnmPLV8BiVVmWI7oPHuqS4QiUCzXXTtt7pLhTVqvxe0ArClDmr
         8EhIq3d/+snV/wYMaUxSBj2iWk6kSa3FjM77f3OrItEPl8EZ/oy3U52DhwRD1K4AGR34
         9JqNYRl3YmUuLVwV8dxUGcnXNPzjPhzxA8PgI=
Date: Fri, 17 Apr 2009 17:20:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] uml: kill a kconfig warning
Message-ID: <20090417092028.GB31897@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Got this warning from Kconfig:

   boolean symbol INPUT tested for 'm'? test forced to 'n'

because INPUT is tristate, not bool. The patch below fixes it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>

--
diff --git a/arch/um/Kconfig.rest b/arch/um/Kconfig.rest
index 7b5cea7..0ccad0f 100644
--- a/arch/um/Kconfig.rest
+++ b/arch/um/Kconfig.rest
@@ -36,7 +36,7 @@ source "drivers/leds/Kconfig"
 
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
-	bool
+	tristate
 	default n
 
 source "arch/um/Kconfig.debug"

