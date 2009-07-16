Return-Path: <linux-kernel-owner+w=401wt.eu-S933371AbZGPU7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbZGPU7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933363AbZGPU7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:59:12 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:34873 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933362AbZGPU7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:59:11 -0400
Subject: Re: [PATCH] TPM: DATA_EXPECT bit check bypass
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andy Isaacson <adi@vmware.com>,
       linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
       adi@hexapodia.org, dds@google.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com
In-Reply-To: <49514.1247774890@turing-police.cc.vt.edu>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
	 <1246410255-6839-6-git-send-email-adi@vmware.com>
	 <20090701110136.576a1d14@lxorguk.ukuu.org.uk>
	 <1246455920.9140.28.camel@blackbox>
	 <1247765210.30736.3.camel@dyn531421.br.ibm.com>
	 <1247766212.30736.17.camel@dyn531421.br.ibm.com>
	 <49514.1247774890@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 17:50:47 -0300
Message-Id: <1247777447.3062.43.camel@dyn531421.br.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 16:08 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Jul 2009 14:43:32 -0300, Rajiv Andrade said:
> 
> > @@ -582,6 +585,12 @@ static int tpm_tis_init(struct device *dev, resource_siz
> e_t start,
> >         tpm_get_timeouts(chip);
> >         tpm_continue_selftest(chip);
> >  
> > +       for (i=0; i < 8; i++)
> > +               if (ITPM_ID[i] != to_pnp_dev(dev)->id->id[i])
> > +                       break;
> > +       if (i == 8)
> > +               chip->is_itpm = 1;
> > +
> 
> strcmp() variant of some sort instead?

Much better, thanks. Forgot that lib/string.c can be handy sometimes :-)

Rajiv

