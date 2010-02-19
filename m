Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab0BSRPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:15:53 -0500
Received: from kroah.org ([198.145.64.141]:57420 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab0BSRAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:20 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:36 2010
Message-Id: <20100219163236.251122510@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [22/93] regulator: Fix display of null constraints for regulators
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 973e9a2795b3b41d8408a0bb6f87b783c5efc88a upstream.

If the regulator constraints are empty and there is no voltage
reported then nothing will be added to the text displayed for the
constraints, leading to random stack data being printed. This is
unlikely to happen for practical regulators since most will at
least report a voltage but should still be fixed.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -640,7 +640,7 @@ static int suspend_prepare(struct regula
 static void print_constraints(struct regulator_dev *rdev)
 {
 	struct regulation_constraints *constraints = rdev->constraints;
-	char buf[80];
+	char buf[80] = "";
 	int count;
 
 	if (rdev->desc->type == REGULATOR_VOLTAGE) {


