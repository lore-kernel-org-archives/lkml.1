Return-Path: <linux-kernel-owner+w=401wt.eu-S1760292AbYFNKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292AbYFNKmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYFNKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:40:25 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:49988 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbYFNKkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:40:14 -0400
Message-ID: <48539E1A.90601@keyaccess.nl>
Date: Sat, 14 Jun 2008 12:31:54 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [patch 18/18] PNP: convert resource options to single linked
 list
References: <20080604220933.168145536@ldl.fc.hp.com> <20080604221130.337606204@ldl.fc.hp.com>
In-Reply-To: <20080604221130.337606204@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 1.0 (+)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05-06-08 00:09, Bjorn Helgaas wrote:

> ISAPNP, PNPBIOS, and ACPI describe the "possible resource settings" of

[ ... ]

Acked-by: Rene Herman <rene.herman@gmail.com>

Only minor comment:

> +static inline unsigned int pnp_independent_option(void)
> +{
> +	return 0;
> +}

I think this is a somewhat unintuitive name (the function doesn't return 
an option) and now that the pnp_dependent_option() one has been renamed 
to pnp_new_dependent_set() even the symmetry doesn't survive.

pnp_independent_option_flags? pnp_independent_flags? Or better yet, just 
literal 0? That last one unless you have some as of yet unpublished plan 
for the abstraction ofcourse but this function seems to obscure more 
than it helps any at the moment.

Even if you agree, obviously also fine as follow-up patch.

Only trivial:

> +static int pnp_assign_resources(struct pnp_dev *dev, int set)
> {

[ ... ]

> -fail:
> -	pnp_clean_resource_table(dev);
>  	mutex_unlock(&pnp_res_mutex);
> -	dbg_pnp_show_resources(dev, "after pnp_assign_resources (failed)");
> -	return 0;
> +	if (ret) {
> +		dev_dbg(&dev->dev, "pnp_assign_resources failed (%d)\n", ret);
> +		pnp_clean_resource_table(dev);
> +	} else
> +		dbg_pnp_show_resources(dev, "pnp_assign_resources succeeded");
> +	return ret;
>  }

if (ret < 0) would agree with the rest.

>  int pnp_auto_config_dev(struct pnp_dev *dev)
>  {
> -	struct pnp_option *dep;
> -	int i = 1;
> +	int i, ret = 0;

int ret; will do;

Rene.

