Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbZGXRNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbZGXRNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZGXRNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:13:09 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:53163 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZGXRNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:13:08 -0400
Subject: Re: [PATCH] TPM: DATA_EXPECT bit check bypass
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andy Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       tpmdd-devel@lists.sourceforge.net, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <20090720232816.GR6370@hexapodia.org>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>
	 <1247765210.30736.3.camel@dyn531421.br.ibm.com>
	 <1247766212.30736.17.camel@dyn531421.br.ibm.com>
	 <49514.1247774890@turing-police.cc.vt.edu>
	 <1247779226.3062.44.camel@dyn531421.br.ibm.com>
	 <20090720232816.GR6370@hexapodia.org>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 14:12:58 -0300
Message-Id: <1248455578.2666.2.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 16:28 -0700, Andy Isaacson wrote:
> On Thu, Jul 16, 2009 at 06:20:26PM -0300, Rajiv Andrade wrote:
> > On Thu, 2009-07-16 at 16:08 -0400, Valdis.Kletnieks@vt.edu wrote:
> > > On Thu, 16 Jul 2009 14:43:32 -0300, Rajiv Andrade said:
> > > 
> > > > @@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_siz
> > > e_t start,
> > > >         tpm_get_timeouts(chip);
> > > >         tpm_continue_selftest(chip);
> > > >  
> > > > +       for (i=0; i < 8; i++)
> > > > +               if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
> > > > +                       break;
> > > > +       if (i == 8)
> > > > +               chip->is_itpm = 1;
> > > > +
> > > 
> > > strcmp() variant of some sort instead?
> > 
> > Wait, is to_pnp_dev(dev)->id->id[i] null terminated? Maybe memcmp() fits
> > better here..
> 
> Rather than checking the PNP ID at this point, I suggest something like:
> 
> (the context here depends on my earlier series, but it's fairly
> obvious.)
> 
> @@ -467,6 +481,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>  		 "1.2 TPM (%04X:%04X rev %d)\n", vendor & 0xffff,
>  		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
> 
> +	if (vendor == 0x10208086) {
> +		dev_info(dev, "Intel iTPM workaround enabled\n");
> +		chip->itpm = 1;
> +	}
> +
>  	/* Figure out the capabilities */
>  	intfcaps =
>  	    ioread32(chip->vendor.iobase +
> 
> (I suppose there should be a #define of 0x10208086 somewhere.)
> 

Much better, my patch would break everything in case force option was
set.

> I'll cook up a refreshed patch series.

Great, I'll ack this one when I get it, thanks.

Rajiv
+++

