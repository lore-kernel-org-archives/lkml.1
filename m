Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYG3Lie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYG3Lie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYG3Li1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:38:27 -0400
Received: from clem.clem-digital.net ([68.16.168.10]:49190 "EHLO
	clem.clem-digital.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbYG3Li0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:38:26 -0400
From: Pete Clements <clem@clem.clem-digital.net>
Message-Id: <200807301138.m6UBc8xe012173@clem.clem-digital.net>
Subject: Re: 2.6.27-rc1 oops on boot -- cs423x? (Corrected subject)
To: bjorn.helgaas@hp.com (Bjorn Helgaas)
Date: Wed, 30 Jul 2008 07:38:08 -0400 (EDT)
Cc: rene.herman@keyaccess.nl (Rene Herman),
       clem@clem.clem-digital.net (Pete Clements),
       linux-kernel@vger.kernel.org (linux-kernel)
In-Reply-To: <200807292159.43226.bjorn.helgaas@hp.com>
X-Mailer: ELM [version 2.5 PL7]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bjorn Helgaas
  > On Tuesday 29 July 2008 6:02:46 pm Rene Herman wrote:
  > > On 29-07-08 22:52, Pete Clements wrote:
  > > > [Previously sent with wrong subject line (2.6.26-rc1...) applicable
  > > > to post 2.6.26 series]
  > > >
  > > > Missed most of the 26-git series, git6 first one tried and oops
  > > > showed in that one as well as those tried after. oops below.
  > >
  > 
  > Thanks very much for the report.  Can I trouble you to test the
  > patch below and see whether it fixes the problem?
  > 

Patch clears the problem. Thanks.
--
Pete Clements

  > 
  > PNP: fix formatting of dbg_pnp_show_resources() output
  > 
  > From: Bjorn Helgaas <bjorn.helgaas@hp.com>
  > 
  > Each resource should be printed on its own line, so start snprintf'ing
  > at the beginning of the buffer every time through the loop.
  > 
  > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
  > ---
  > 
  >  drivers/pnp/support.c |    3 ++-
  >  1 files changed, 2 insertions(+), 1 deletions(-)
  > 
  > 
  > diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
  > index bbf78ef..57b775b 100644
  > --- a/drivers/pnp/support.c
  > +++ b/drivers/pnp/support.c
  > @@ -77,7 +77,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
  >  {
  >  #ifdef DEBUG
  >  	char buf[128];
  > -	int len = 0;
  > +	int len;
  >  	struct pnp_resource *pnp_res;
  >  	struct resource *res;
  >  
  > @@ -89,6 +89,7 @@ void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
  >  	dev_dbg(&dev->dev, "%s: current resources:\n", desc);
  >  	list_for_each_entry(pnp_res, &dev->resources, list) {
  >  		res = &pnp_res->res;
  > +		len = 0;
  >  
  >  		len += snprintf(buf + len, sizeof(buf) - len, "  %-3s ",
  >  				pnp_resource_type_name(res));
  > 
