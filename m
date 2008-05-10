Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbYEJVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbYEJVrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYEJVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 17:47:23 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:44104 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYEJVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 17:46:53 -0400
Message-ID: <48261820.3020909@gmail.com>
Date: Sat, 10 May 2008 23:48:16 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Uwe Bugla <uwe.bugla@gmx.de>, Takashi Iwai <tiwai@suse.de>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] PNP: add pnp_build_option() to the API
References: <481FAF79.2030407@keyaccess.nl> <200805061115.56737.bjorn.helgaas@hp.com> <482614B3.4000908@gmail.com>
In-Reply-To: <482614B3.4000908@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.5 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

===
PNP: add pnp_build_option() to the API

The subsequent ISAPnP MPU quirk patch would like this as part of the
API. pnp_register_dependent_option() adds to the same dependent chain
the quirk is walking which is fairly unclean. This enables a private
option chain build which it can then just add onto the end when done.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
drivers/pnp/base.h     |    1 +
drivers/pnp/resource.c |    2 +-
2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pnp/base.h b/drivers/pnp/base.h
index 4fe7c58..886dac8 100644
--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -19,6 +19,7 @@ void pnp_remove_card(struct pnp_card *card);
int pnp_add_card_device(struct pnp_card *card, struct pnp_dev *dev);
void pnp_remove_card_device(struct pnp_dev *dev);

+struct pnp_option *pnp_build_option(int priority);
struct pnp_option *pnp_register_independent_option(struct pnp_dev *dev);
struct pnp_option *pnp_register_dependent_option(struct pnp_dev *dev,
						 int priority);
diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index 2041620..390b500 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -28,7 +28,7 @@ static int pnp_reserve_mem[16] = {[0 ... 15] = -1 };	/* reserve (don't use) some
* option registration
*/

-static struct pnp_option *pnp_build_option(int priority)
+struct pnp_option *pnp_build_option(int priority)
{
	struct pnp_option *option = pnp_alloc(sizeof(struct pnp_option));

-- 
1.5.2.2



