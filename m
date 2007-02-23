Return-Path: <linux-kernel-owner+w=401wt.eu-S1750996AbXBWXcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750996AbXBWXcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 18:32:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXBWXcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 18:32:14 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:9675 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXBWXcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 18:32:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dkqpIHA0LNCCKlgM/OJ7LoElCEnH5ae6xypJLWsbkKAO89S0uka4tHLPhekh4gY0nJohcFWM43oinRMlTiTsGx2JA0X0u4WrZXGAPPCDa5cOiMpqfWZXJ8Awz6BwtINXyCQOy0WlkF5STdXeYIEYJNkbpeqxO2OugYPVo+EEGd0=
Date: Sat, 24 Feb 2007 02:32:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: parisc-linux@parisc-linux.org, linux-kernel@vger.kernel.org
Subject: [PATCH] parisc: unbreak setup.c re command_line
Message-ID: <20070223233226.GC5599@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

What compiler is supposed to do upon seeing

	char __attribute__((__section__ (".init.data")))	command_line[1024]
	     __attribute__((__section__(".data.read_mostly")));

?

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/parisc/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -45,7 +45,7 @@ #include <asm/pdc_chassis.h>
 #include <asm/io.h>
 #include <asm/setup.h>
 
-char	__initdata command_line[COMMAND_LINE_SIZE] __read_mostly;
+static char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* Intended for ccio/sba/cpu statistics under /proc/bus/{runway|gsc} */
 struct proc_dir_entry * proc_runway_root __read_mostly = NULL;

