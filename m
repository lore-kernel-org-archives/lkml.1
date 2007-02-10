Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXBJLCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXBJLCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbXBJLCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:02:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:33900 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXBJLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:02:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=GYOntCGhKI2SpVIxKNqtqqUFhoQ/VbNmh1rJIxH8mw8JlxGLoBx7ymY6QpXTRw2AH2DN9EnGf4KRIbnO+fGNQNlwlxLNhJ00h5L8ry5CIneYPyYceVzRAtX7LyEVvqk4AonDuzXFt5WtBK8Iz+4VtAh/YPXJi7VC0x3wx7QblG0=
Date: Sat, 10 Feb 2007 14:00:14 +0300
From: "Cyrill V. Gorcunov" <gorcunov@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       "Cyrill V. Gorcunov" <gorcunov@gmail.com>
Subject: [PATCH] qconf: hide empty list items
Message-ID: <20070210110014.GA15932@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes showing empty config list items
if "Option/Show All Options" is turned on. For example
empty items appears on list of 'Block Layer' menu.

Signed-off-by: Cyrill V. Gorcunov <gorcunov@gmail.com>

---

Roman, this patch is temporary solution only. The problem
is growing from the code that creates menu items I guess.

 scripts/kconfig/qconf.cc |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index c0ae0a7..d254e37 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -605,6 +605,8 @@ void ConfigList::updateMenuList(P* parent, struct menu* menu)
 
 		visible = menu_is_visible(child);
 		if (showAll || visible) {
+			if (!child->sym && !child->list && !child->prompt)
+				continue;
 			if (!item || item->menu != child)
 				item = new ConfigItem(parent, last, child, visible);
 			else
