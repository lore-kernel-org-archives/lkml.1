Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZAUW1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZAUW1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZAUW10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:27:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:8267 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZAUW1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:27:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ETAKf9HIZqtmrWt581EcOXtQvxP2GvShd8Hiz7uXjviXgUd/S83Sd5EfQCLhBTKx6G
         N8XU+OwE2A/Bj3K1Gk4dXV95TvsWer1G1eTpks/vbbGLTDvL2RhRch2uouMWmGp7oITB
         Q94/biXXmpBEdhH6TG20+j+7dpttwZDABvopA=
Date: Thu, 22 Jan 2009 01:32:54 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org
Cc: albcamus@gmail.com, linux-kernel@vger.kernel.org
Subject: tags: fix config symbols generation
Message-ID: <20090121223253.GB10123@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 4f628248a578585472e19e4cba2c604643af8c6c aka
"kbuild: reintroduce ALLSOURCE_ARCHS support for tags/cscope"
breaks tags generation for Kconfig symbols.

Steps to reproduce:

	make tags
	vi -t PROC_FS

It should jump to 'config PROC_FS' line.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 scripts/tags.sh |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -76,7 +76,10 @@ all_sources()
 
 all_kconfigs()
 {
-	find_sources $ALLSOURCE_ARCHS 'Kconfig*'
+	for arch in $ALLSOURCE_ARCHS; do
+		find_sources $arch 'Kconfig*'
+	done
+	find_other_sources 'Kconfig*'
 }
 
 all_defconfigs()
