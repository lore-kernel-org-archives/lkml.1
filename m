Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYA1JmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYA1JmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYA1JmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:42:03 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:35826 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYA1JmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:42:00 -0500
Date: Mon, 28 Jan 2008 15:11:42 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
Message-ID: <20080128094142.GA4330@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Nish Aravamudan <nish.aravamudan@gmail.com>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
	LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop> <1200634493.7806.0.camel@concordia.ozlabs.ibm.com> <1200635099.7806.3.camel@concordia.ozlabs.ibm.com> <20080126071339.GA25328@balbir.in.ibm.com> <18332.28991.658933.763115@cargo.ozlabs.ibm.com> <20080127150147.GA10914@balbir.in.ibm.com> <29495f1d0801271222l3f52935fq40df4dcb82e60976@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <29495f1d0801271222l3f52935fq40df4dcb82e60976@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nish Aravamudan <nish.aravamudan@gmail.com> [2008-01-27 12:22:54]:

> On 1/27/08, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > * Paul Mackerras <paulus@samba.org> [2008-01-27 22:55:43]:
> >
> > > Balbir Singh writes:
> > >
> > > > Here's a better and more complete fix for the problem. Could you
> > > > please see if it works for you? I tested it on a real NUMA box and it
> > > > seemed to work fine there.
> > >
> > > There are a couple of other changes in behaviour that your patch
> > > introduces, and I'd like to understand them better before taking the
> > > patch.  First, with your patch we don't set nodes online if they end
> > > up having no memory in them because of the memory limit, whereas
> > > previously we did.  Secondly, in the case where we don't have NUMA
> > > information, we now set node 0 online after adding each LMB, whereas
> > > previously we only set it online once.
> > >
> > > If in fact these changes are benign, then your patch description
> > > should mention them and explain why they are benign.
> > >
> >
> > Yes, they are. I'll try and justify the changes with a good detailed
> > changelog. If people prefer it, I can hide fake NUMA nodes under a
> > config option, so that it does not come enabled by default.
> 
> Sigh, there already *is* a fake NUMA config option: CONFIG_NUMA_EMU.
>
> "CONFIG_NUMA_EMU:
>   Enable NUMA emulation. A flat machine will be split
>   into virtual nodes when booted with "numa=fake=N", where N is the
>   number of nodes. This is only useful for debugging."
> 
> I have to assume your patch is implementing the same feature for
> powerpc (really just extending the x86_64 one), and thus should share
> the config option.
>
> Any chance you can just make some of that code common? Maybe as a
> follow-on patch. I expect that some of Mel's (added to Cc) work to
> allow NUMA to be set on x86 more easily will flow quite simply into
> adding fake NUMA support there as well. So moving the code to a common
> place (at least the parsing) makes sense.
>

That's the long term plan and we discussed using common code in the
discussion thread for fake NUMA (for PowerPC). We'll get there in
steps. My patch is the basic initial, simple method for implementing
fake NUMA nodes.
 
> I also feel like you want to be able to online memoryless nodes --
> that's where we've been hitting a number of bugs lately in the VM. I
> can't tell from Paul's comment if your patch prevents that from being
> faked or not.
> 

My patch prevents nodes from being enabled if we cross the memory
limit. Earlier they were being enabled.


> Thanks,
> Nish
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
