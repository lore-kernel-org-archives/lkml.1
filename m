Return-Path: <linux-kernel-owner+w=401wt.eu-S1751920AbYG3EAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbYG3EAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 00:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbYG3EAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 00:00:40 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:24711 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYG3EAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 00:00:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
Date: Tue, 29 Jul 2008 21:59:43 -0600
User-Agent: KMail/1.9.9
Cc: Pete Clements <clem@clem.clem-digital.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200807292052.m6TKq1J3005288@clem.clem-digital.net> <488FAFA6.4070300@keyaccess.nl>
In-Reply-To: <488FAFA6.4070300@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807292159.43226.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 6:02:46 pm Rene Herman wrote:
> On 29-07-08 22:52, Pete Clements wrote:
> > [Previously sent with wrong subject line (2.6.26-rc1...) applicable
> > to post 2.6.26 series]
> >
> > Missed most of the 26-git series, git6 first one tried and oops
> > showed in that one as well as those tried after. oops below.
>
> http://marc.info/?l=linux-kernel&m=121736480005656&w=2
>
> For now just adding a CC as I'm off to bed. Note -- snd-cs4236 has been
> one of the most tested drivers with the new PNP code.

Thanks very much for the report.  Can I trouble you to test the
patch below and see whether it fixes the problem?



PNP: fix formatting of dbg_pnp_show_resources() output

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Each resource should be printed on its own line, so start snprintf'ing
at the beginning of the buffer every time through the loop.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/support.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index bbf78ef..57b775b 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -77,7 +77,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 {
 #ifdef DEBUG
 	char buf[128];
-	int len = 0;
+	int len;
 	struct pnp_resource *pnp_res;
 	struct resource *res;
 
@@ -89,6 +89,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
 	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
 	list_for_each_entry(pnp_res, &dev->resources, list) {
 		res = &pnp_res->res;
+		len = 0;
 
 		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
 				pnp_resource_type_name(res));
