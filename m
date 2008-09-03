Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbYICLuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbYICLuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYICLui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:50:38 -0400
Received: from styx.suse.cz ([82.119.242.94]:56756 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332AbYICLuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:50:37 -0400
Date: Wed, 3 Sep 2008 13:50:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Daniel Barkalow <barkalow@iabervon.org>, linux-kernel@vger.kernel.org,
       Christopher Desjardins <cddesjardins@gmail.com>
Subject: Re: Lenovo 3000 N100 i8042 problems
In-Reply-To: <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
Message-ID: <alpine.LNX.1.10.0809031349081.23448@jikos.suse.cz>
References: <alpine.LNX.1.00.0808240148580.19665@iabervon.org> <Pine.LNX.4.64.0809020120130.29111@twin.jikos.cz> <alpine.LNX.1.00.0809012014280.19665@iabervon.org> <alpine.LNX.1.10.0809021121410.23448@jikos.suse.cz>
 <20080902083940.ZZRA012@mailhub.coreip.homeip.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2008, Dmitry Torokhov wrote:

> I guess we could use System's product name to differentiate between 
> Cristopher's and Daniel's boards. Although I must admit it is the very 
> first time when I see a box that behaves better with active mux. DOes 
> Vista use active mux nowadays? Because if it is not then I bet there is 
> (or shortly will be) a BIOS update fixing legacy mode on Daniel's box.

I guess so, yes.

On the other hand, this might also be viewed as regression (we made 
Daniel's hardware behave worse with recent kernel than it did before), so 
I think we still would like to have this fixed. What about the patch 
below, adding the match on System's product name, as you suggested? 
Thanks.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Input: i8042 - make Lenovo 3000 N100 blacklist entry more specific

Apparently, there are more different versions of Lenovo 3000 N100, some
of them working properly with active mux, and some of them requiring it
being switched off.

This patch applies 'nomux' only to the specific product name that is
reported to behave badly unless 'nomux' is specified.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/input/serio/i8042-x86ia64io.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 3282b74..5aafe24 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -305,7 +305,7 @@ static struct dmi_system_id __initdata i8042_dmi_nomux_table[] = {
 		.ident = "Lenovo 3000 n100",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "3000 N100"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "076804U"),
 		},
 	},
 	{
-- 
1.5.4.5
