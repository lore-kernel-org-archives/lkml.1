Return-Path: <linux-kernel-owner+w=401wt.eu-S965093AbZLQEcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093AbZLQEcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936560AbZLQEcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:32:00 -0500
Received: from kroah.org ([198.145.64.141]:55637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935652AbZLQEEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:36 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:52 2009
Message-Id: <20091217035652.337874793@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [073/151] powerpc/windfarm: Add detection for second cpu pump
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bolko Maass <krautilein@gmx.de>

commit 529586dc39b0ec47c6290c4e7bed6ea3ffd1d8fb upstream.

Windfarm SMU control is explicitly missing support for a second CPU pump in G5 PowerMacs. Such machines actually exist  (specifically Quads with a second pump), so this patch adds detection for it.

Signed-off by: Bolko Maass <bmaass@math.uni-bremen.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/macintosh/windfarm_smu_controls.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/macintosh/windfarm_smu_controls.c
+++ b/drivers/macintosh/windfarm_smu_controls.c
@@ -202,6 +202,8 @@ static struct smu_fan_control *smu_fan_c
 		fct->ctrl.name = "cpu-front-fan-1";
 	else if (!strcmp(l, "CPU A PUMP"))
 		fct->ctrl.name = "cpu-pump-0";
+	else if (!strcmp(l, "CPU B PUMP"))
+		fct->ctrl.name = "cpu-pump-1";
 	else if (!strcmp(l, "Slots Fan") || !strcmp(l, "Slots fan") ||
 		 !strcmp(l, "EXPANSION SLOTS INTAKE"))
 		fct->ctrl.name = "slots-fan";


