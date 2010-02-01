Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab0BAATA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 19:19:00 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:60611 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab0BAAS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 19:18:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=rZk7NswgGCsp+CqGAas3CLCLs4XQjynBOxcH7K07hF3fsnkRLlPUcd5HLfwQc5dYJO
         TnzPlkZ1EFvB7xyw7kLghfFwkeYde580yjFrlVkAwOhYFdcX/+sh6oqIiWU38/oV4P+S
         wHjfIyLrcOD7qQe1tunxxGOu9E7Pv6zLtOdbY=
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 16:18:58 -0800
Message-ID: <506c8f0b1001311618i3b8f72c5w9321e3ef26413a20@mail.gmail.com>
Subject: [PATCH] scripts: use %_tmppath in "make rpm-pkg"
From: John Saalwaechter <saalwaechter@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mkspec script hardcodes "/var/tmp" into the generated rpm spec file's
BuildRoot. The user, however, may have a custom setting for %_tmppath,
which should be used in BuildRoot.  This patch changes mkspec's
BuildRoot output to appropriately use %_tmppath.

Signed-off-by: John Saalwaechter <saalwaechter@gmail.com>
---
diff -uprN a/scripts/package/mkspec b/scripts/package/mkspec
--- a/scripts/package/mkspec    2010-01-28 15:06:20.000000000 -0800
+++ b/scripts/package/mkspec    2010-01-31 15:46:23.815300460 -0800
@@ -39,7 +39,7 @@ if ! $PREBUILT; then
 echo "Source: kernel-$__KERNELRELEASE.tar.gz"
 fi

-echo "BuildRoot: /var/tmp/%{name}-%{PACKAGE_VERSION}-root"
+echo "BuildRoot: %{_tmppath}/%{name}-%{PACKAGE_VERSION}-root"
 echo "Provides: $PROVIDES"
 echo "%define __spec_install_post /usr/lib/rpm/brp-compress || :"
 echo "%define debug_package %{nil}"
