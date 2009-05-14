Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZENQzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZENQzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:55:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZENQz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:55:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:52830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbZENQz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:55:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Poselenov <sposelenov@emcraft.com>
Subject: Re: 'make headers_check' failed to install headers to arbitrary location
Date: Thu, 14 May 2009 18:54:37 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <4A0C3BFB.1010305@emcraft.com>
In-Reply-To: <4A0C3BFB.1010305@emcraft.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905141854.37869.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+UZTvrVUIzVefUVsrQWUFG3J+JkPdFsX0pMNK
 75xMjQdOKIR9MHgx/ii4Q8JA0d6C8xeXEZufolMydil5t2veme
 EBzJGEIUt+rdPKGjaGJ9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Sergei Poselenov wrote:
>    CHECK   include/linux/tc_ematch (4 files)
>    CHECK   include/linux/usb (8 files)
> make[2]: execvp: /bin/sh: Argument list too long
> make[2]: *** 

Can you try this patch?

	Arnd <><

--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -54,8 +54,8 @@ quiet_cmd_remove = REMOVE  $(unwanted)
       cmd_remove = rm -f $(unwanted-file)
 
 quiet_cmd_check = CHECK   $(printdir) ($(words $(all-files)) files)
-      cmd_check = $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) \
-                  $(addprefix $(install)/, $(all-files));           \
+      cmd_check = echo $(addprefix $(install)/, $(all-files)) | \
+		  xargs $(PERL) $< $(INSTALL_HDR_PATH)/include $(SRCARCH) ; \
 	          touch $@
 
 PHONY += __headersinst __headerscheck
