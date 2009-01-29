Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZA2KUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZA2KUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZA2KUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:20:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:29471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZA2KUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:20:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=QhnpX+2agBma+qy2jMFKp4r3GtFbHqVM7CT+YEpR2M8vR3pCl1LNbjNJve/+CTvPav
         0nlyi+f7gieDguX49Zr7sfy3mIwzQDh3LxO8hdMpLafvYD0dLeKxQzqNoY73RjBuR4mJ
         /Ud5ORNZXpH2xN0cklhu9UWQ47fMvIhasPGY0=
Date: Thu, 29 Jan 2009 13:26:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: sam@ravnborg.org, akpm@osdl.org
Cc: albcamus@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] tags: fix config symbols generation
Message-ID: <20090129102618.GB4425@x200.localdomain>
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
