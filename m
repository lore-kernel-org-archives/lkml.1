Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430Ab0AFG0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0AFG0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 01:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367Ab0AFG0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 01:26:23 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:63828 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0AFG0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 01:26:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=IzO/XrmV/j/Lu0hEMoSEXPjlZXJp2LXfNyEv9Cn2gGtnIiRbn5MGbKyBLXGBAuZ6uJ
         Rr634+Qexl2rIm0dZ9jyEKXSHboqzlZaC6BX6g2NB9pANpl+5nWF+og0tZy3JQqbzDxq
         fb+oZGBPE7TRE/k1b5eATbfucvy1pZUNRu4XE=
MIME-Version: 1.0
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 14:26:01 +0800
Message-ID: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com>
Subject: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit aa7c411671269a75ed7adc0452851bf2cffd839e
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Wed Jan 6 13:58:22 2010 +0800

    kbuild: include only necessary in scripts/Makefile.modbuiltin

    scripts/Makefile.modbuiltin assumes either Kbuild or Makefile exists in
    every sub-directory, which is not true. Only include them when they are
    existing.

    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/scripts/Makefile.modbuiltin b/scripts/Makefile.modbuiltin
index 102a276..9148a70 100644
--- a/scripts/Makefile.modbuiltin
+++ b/scripts/Makefile.modbuiltin
@@ -17,7 +17,7 @@ include scripts/Kbuild.include
 # The filename Kbuild has precedence over Makefile
 kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
 kbuild-file := $(if $(wildcard
$(kbuild-dir)/Kbuild),$(kbuild-dir)/Kbuild,$(kbuild-dir)/Makefile)
-include $(kbuild-file)
+-include $(kbuild-file)

 include scripts/Makefile.lib
 __subdir-Y     := $(patsubst %/,%,$(filter %/, $(obj-Y)))
