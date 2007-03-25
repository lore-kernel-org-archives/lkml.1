Return-Path: <linux-kernel-owner+w=401wt.eu-S1751698AbXCYPao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbXCYPao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbXCYPao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:30:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:17714 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbXCYPaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:30:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:x-google-sender-auth;
        b=YbUk1Ye9BEo/nuBwkZtAdMjjFp+UpDpZozHc+X4yWQ8ONoxcbcQ5k73aoYAoxbZbl+kjCVO61lx0yF8VeEObfiQPBzK4p1PYht6MyEhF6ywwODUbyDZRhHnlK5OgE0oXmQpg5SB0TgZTjBVO84AVxa/jvq1tXM2itE31sdUUxQQ=
Message-ID: <4301cff60703250830u7967299pdb2071dda34c4426@mail.gmail.com>
Date: Sun, 25 Mar 2007 18:30:16 +0300
From: "Mika Kukkonen" <mikukkon@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix kernel build with EMBEDDED & PROC_FS & !PROC_SYSCTL
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_242474_22495142.1174836616629"
X-Google-Sender-Auth: 5620e4aea0116e77
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_242474_22495142.1174836616629
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Without attached patch against current -git I get following with
!PROC_SYSCTL (with EMBEDDED and PROC_FS set):

  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
fs/built-in.o: In function `do_proc_sys_lookup':
proc_sysctl.c:(.text+0x26583): undefined reference to `sysctl_head_next'
fs/built-in.o: In function `proc_sys_revalidate':
proc_sysctl.c:(.text+0x265bb): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_readdir':
proc_sysctl.c:(.text+0x26720): undefined reference to `sysctl_head_next'
proc_sysctl.c:(.text+0x267d8): undefined reference to `sysctl_head_finish'
proc_sysctl.c:(.text+0x268e7): undefined reference to `sysctl_head_next'
proc_sysctl.c:(.text+0x26910): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_write':
proc_sysctl.c:(.text+0x2695d): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x2699c): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_read':
proc_sysctl.c:(.text+0x269e9): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x26a25): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_permission':
proc_sysctl.c:(.text+0x26ad1): undefined reference to `sysctl_perm'
proc_sysctl.c:(.text+0x26adb): undefined reference to `sysctl_head_finish'
fs/built-in.o: In function `proc_sys_lookup':
proc_sysctl.c:(.text+0x26b39): undefined reference to `sysctl_head_finish'
make: *** [vmlinux] Virhe 1

All those functions are in fs/proc/proc_sysctl.c, which has no CONFIG_
#define's in it, so the patch makes the compilation of that file to depend
on CONFIG_PROC_SYSCTL (the simplest choice).

Patch is compile tested only, but should not break anything.

--MiKu

------=_Part_242474_22495142.1174836616629
Content-Type: text/x-patch; name=fs_proc_Makefile.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ezpn4xm8
Content-Disposition: attachment; filename="fs_proc_Makefile.patch"

ZGlmZiAtLWdpdCBhL2ZzL3Byb2MvTWFrZWZpbGUgYi9mcy9wcm9jL01ha2VmaWxlCmluZGV4IGE2
YjNhOGYuLmJjZTM4ZTMgMTAwNjQ0Ci0tLSBhL2ZzL3Byb2MvTWFrZWZpbGUKKysrIGIvZnMvcHJv
Yy9NYWtlZmlsZQpAQCAtOCw4ICs4LDkgQEAgcHJvYy15CQkJOj0gbm9tbXUubyB0YXNrX25vbW11
Lm8KIHByb2MtJChDT05GSUdfTU1VKQk6PSBtbXUubyB0YXNrX21tdS5vCiAKIHByb2MteSAgICAg
ICArPSBpbm9kZS5vIHJvb3QubyBiYXNlLm8gZ2VuZXJpYy5vIGFycmF5Lm8gXAotCQlwcm9jX3R0
eS5vIHByb2NfbWlzYy5vIHByb2Nfc3lzY3RsLm8KKwkJcHJvY190dHkubyBwcm9jX21pc2Mubwog
Citwcm9jLSQoQ09ORklHX1BST0NfU1lTQ1RMKQkrPSBwcm9jX3N5c2N0bC5vCiBwcm9jLSQoQ09O
RklHX1BST0NfS0NPUkUpCSs9IGtjb3JlLm8KIHByb2MtJChDT05GSUdfUFJPQ19WTUNPUkUpCSs9
IHZtY29yZS5vCiBwcm9jLSQoQ09ORklHX1BST0NfREVWSUNFVFJFRSkJKz0gcHJvY19kZXZ0cmVl
Lm8K
------=_Part_242474_22495142.1174836616629--
