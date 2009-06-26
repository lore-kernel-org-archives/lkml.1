Return-Path: <linux-kernel-owner+w=401wt.eu-S1756995AbZFZQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995AbZFZQv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZFZQvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:51:20 -0400
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:36066 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751026AbZFZQvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:51:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=jMQIsZrJCc0h5cCk0kH3GcEnDQ0YcInCTvoI509xDVtnNr3iTRi9sdU6+9+5PMmLYSeuQWDzimE44qoKR99Hk32HzZXaVVepw7/JER0SOg/mnESQ9e9l55Fdu81ycqNB;
Date: Fri, 26 Jun 2009 09:51:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626095119.15067a53@jbarnes-g45>
In-Reply-To: <20090626071955.GG14078@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
	<20090626071955.GG14078@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.17.2; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009 09:19:55 +0200
Ingo Molnar <mingo@elte.hu> wrote:
> >  void platform_feature_init_default(int subarch_id)
> >  {
> > -	printk(KERN_INFO "Use default X86 platform feature set\n");
> > +	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {
> > +		if (subarch_id == X86_SUBARCH_MRST) {
> > +			setup_mrst_default_feature();
> > +			return;
> > +		}
> > +	} else {
> > +		printk(KERN_INFO "Use default X86 platform feature
> > set\n");
> > +	}
> >  }
> 
> Why dont we have some clean and robust PCI config space based 
> enumeration instead of this boot ID based thing?

MRST has special PCI support that depends on having the platform
identified already, so if you want to use something other than a flag
here, maybe we could use an SFI string instead.

-- 
Jesse Barnes, Intel Open Source Technology Center
