Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZICWAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZICWAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 18:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932269AbZICWAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 18:00:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40328 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755267AbZICWAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 18:00:32 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: maximilian attems <max@stro.at>, Frans Pop <elendil@planet.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 03 Sep 2009 23:00:31 +0100
Message-Id: <1252015231.3475.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH] builddeb: Fix packaged file permissions
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The packaged files' permissions are implicitly dependent on the
current umask.  Not only can this result in surprisingly restrictive
permissions, but dpkg-deb will fail if the DEBIAN directory does not
have permissions 755 or 775.  Therefore, set the umask to 022 before
building a package.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/package/builddeb |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/package/builddeb b/scripts/package/builddeb
index 8b357b0..24cfd80 100644
--- a/scripts/package/builddeb
+++ b/scripts/package/builddeb
@@ -12,6 +12,8 @@
 
 set -e
 
+umask 022
+
 create_package() {
 	local pname="$1" pdir="$2"
 
-- 
1.6.3.3

