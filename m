Return-Path: <linux-kernel-owner+w=401wt.eu-S934301AbXGLU4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934301AbXGLU4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbXGLU4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:56:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:46982 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332AbXGLU4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:56:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=lhCR1N9gSOx5sZQoG3qESFucSuZXbWwM4ngsxGA+G+/CSIYqyIwBgD8sOul/uflJEtfkQzyAzNAR5mnkywT/e6oLzqebHZSDZulu9U4byjED5lzsZ7AIOzHSXqLusXgluUc37kXq88lyvqVfyq5wZaq95bp2iuOmfmSscRqLg8k=
Message-ID: <46969586.5050507@googlemail.com>
Date: Thu, 12 Jul 2007 22:56:38 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: trivial@kernel.org
Subject: [PATCH] broken lilo check on make install
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on make install I get the this error:

...

sh /work/crazy/linux-git/linux-2.6/arch/i386/boot/install.sh
2.6.22-g4eb6bf6b arch/i386/boot/bzImage System.map "/boot"
/work/crazy/linux-git/linux-2.6/arch/i386/boot/install.sh: line 54:
/etc/lilo/install: No such file or directory
make[1]: *** [install] Error 127

...

I don't use and don't have lilo installed on this system. The attached
patch fixes the problem for me.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>


diff --git a/arch/i386/boot/install.sh b/arch/i386/boot/install.sh
index 5e44c73..7099fd6 100644
--- a/arch/i386/boot/install.sh
+++ b/arch/i386/boot/install.sh
@@ -51,4 +51,10 @@ fi
 cat $2 > $4/vmlinuz
 cp $3 $4/System.map
 
-if [ -x /sbin/lilo ]; then /sbin/lilo; else /etc/lilo/install; fi
+if [ -x /sbin/lilo ]; then
+       /sbin/lilo
+elif [ -x /etc/lilo/install ]; then
+       /etc/lilo/install
+else
+       echo "Cannot find LILO."
+fi

