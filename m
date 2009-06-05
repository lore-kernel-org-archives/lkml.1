Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZFEXnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZFEXnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZFEXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:32 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36412 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH 17/39] kbuild: fix header export when __ASSEMBLY__ is used
Date: Sat,  6 Jun 2009 01:42:35 +0200
Message-Id: <1244245377-17441-17-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unifdef got confused by:

Because it does not know __ASSEMBLY__ it does not
detect that htis is not for userspace.
This caused too much code to be exported, and headers_check barfed
over this code.

For arm this fixes following "make headers_check" warning:
/usr/include/asm/hwcap.h:29: extern's make no sense in userspace

Russell King suggested to undefine __ASSEMBLY__ to fix this warning.

Cc: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers_install.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
index c6ae405..bc70ea6 100644
--- a/scripts/headers_install.pl
+++ b/scripts/headers_install.pl
@@ -20,7 +20,7 @@ use strict;
 
 my ($readdir, $installdir, $arch, @files) = @ARGV;
 
-my $unifdef = "scripts/unifdef -U__KERNEL__";
+my $unifdef = "scripts/unifdef -U__KERNEL__ -U__ASSEMBLY__";
 
 foreach my $file (@files) {
 	local *INFILE;
-- 
1.6.3.rc3.40.g75b44

