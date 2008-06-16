Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbYFPPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbYFPPof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYFPPo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:44:27 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:35234 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYFPPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:44:26 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 18/18] PNP: convert resource options to single linked list
Date: Mon, 16 Jun 2008 09:44:00 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221130.337606204@ldl.fc.hp.com> <48539E1A.90601@keyaccess.nl>
In-Reply-To: <48539E1A.90601@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806160944.00848.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 June 2008 04:31:54 am Rene Herman wrote:
> On 05-06-08 00:09, Bjorn Helgaas wrote:
> 
> > ISAPNP, PNPBIOS, and ACPI describe the "possible resource settings" of
> 
> [ ... ]
> 
> Acked-by: Rene Herman <rene.herman@gmail.com>
> 
> Only minor comment:
> 
> > +static inline unsigned int pnp_independent_option(void)
> > +{
> > +	return 0;
> > +}
> 
> I think this is a somewhat unintuitive name (the function doesn't return 
> an option) and now that the pnp_dependent_option() one has been renamed 
> to pnp_new_dependent_set() even the symmetry doesn't survive.
> 
> pnp_independent_option_flags? pnp_independent_flags? Or better yet, just 
> literal 0? That last one unless you have some as of yet unpublished plan 
> for the abstraction ofcourse but this function seems to obscure more 
> than it helps any at the moment.

Yep, you're absolutely right.  I changed the dependent name at the
last minute and should have done something with independent at the
same time.  I like the literal 0 idea.

> Only trivial:
> 
> > +static int pnp_assign_resources(struct pnp_dev *dev, int set)
> > {
> 
> [ ... ]
> 
> > -fail:
> > -	pnp_clean_resource_table(dev);
> >  	mutex_unlock(&pnp_res_mutex);
> > -	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
> > -	return 0;
> > +	if (ret) {
> > +		dev_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
> > +		pnp_clean_resource_table(dev);
> > +	} else
> > +		dbg_pnp_show_resources(dev, "pnp_assign_resources succeeded");
> > +	return ret;
> >  }
> 
> if (ret < 0) would agree with the rest.
> 
> >  int pnp_auto_config_dev(struct pnp_dev *dev)
> >  {
> > -	struct pnp_option *dep;
> > -	int i = 1;
> > +	int i, ret = 0;
> 
> int ret; will do;

Thanks, I'll fold those in, too.

Bjorn
