Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYFMOkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYFMOkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbYFMOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:39:51 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39089 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbYFMOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:39:51 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH REPOST] IB/ehca: In case of lost interrupts, trigger EOI to reenable interrupts
Date: Fri, 13 Jun 2008 16:39:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Roland Dreier <rolandd@cisco.com>, Paul Mackerras <paulus@samba.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>, general@lists.openfabrics.org,
       fenkes@de.ibm.com, raisch@de.ibm.com, hnguyen@de.ibm.com,
       TKLEIN@de.ibm.com, THEMANN@de.ibm.com
References: <200806101644.34693.ossrosch@linux.vnet.ibm.com> <200806101701.47090.ossrosch@linux.vnet.ibm.com> <adaabht5klx.fsf@cisco.com>
In-Reply-To: <adaabht5klx.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806131639.43173.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

On Tuesday 10 June 2008 18:18:50 Roland Dreier wrote:
>  > > So just to be clear: this is a workaround for a hardware/firmware bug?
> 
>  > Yes it is.
> 
> OK, so paulus et al... does it seem like a good approach to call H_EOI
> from driver code (given that this driver makes tons of other hcalls)?
> 
> How critical is this?  Since you said "corner case testing" I suspect we
> can defer this to 2.6.27 and maybe get it into -stable later?

No, it's ok with me if you pick this for 2.6.27.
> 
> Also, out of curiousity:
> 
>  > +u64 hipz_h_eoi(int irq)
>  > +{
>  > +	int value;
>  > +	unsigned long xirr;
>  > +
>  > +	iosync();
> 
> what is the iosync() required for here?

It's the same sequence as the interrupt handler for powerpc is implemented.

> 
>  > +	value = (0xff << 24) | irq;
>  > +	xirr = value & 0xffffffff;
> 
> given that irq and value are ints, is there any possible way value could
> have bits outside of the low 32 set?  If you're worried about sign
> extension isn't it simpler to just make value unsigned?
> 
>  > +	return plpar_hcall_norets(H_EOI, xirr);
>  > +}
> 
> ie why not:
> 
> u64 hipz_h_eoi(int irq)
> {
> 	unsigned xirr;
> 
> 	iosync();
> 	xirr = (0xff << 24) | irq;
> 	return plpar_hcall_norets(H_EOI, xirr);
> }
> 
Yeah, you are rigth I will change that with the final patch.
I will send the final patch soon.

regards Stefan


