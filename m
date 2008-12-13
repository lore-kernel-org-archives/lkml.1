Return-Path: <linux-kernel-owner+w=401wt.eu-S1757210AbYLMJzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbYLMJzZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 04:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755116AbYLMJzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 04:55:13 -0500
Received: from ozlabs.org ([203.10.76.45]:35728 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbYLMJzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 04:55:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 1/1] cpumask: force nr_cpumask_bit to NR_CPUS for CPUMASK_OFFSTACK=n
Date: Sat, 13 Dec 2008 20:25:05 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@googlemail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Tony Luck <tony.luck@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <200812082136.33212.rusty@rustcorp.com.au> <200812101019.42908.rusty@rustcorp.com.au> <49417B99.7090004@sgi.com>
In-Reply-To: <49417B99.7090004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812132025.06514.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 07:14:09 Mike Travis wrote:
> Re: cpumask conversions, or not?
> 
> Rusty Russell wrote:
> > On Tuesday 09 December 2008 21:26:36 Mike Travis wrote:
> >> Rusty Russell wrote:
> >>> Hi all,
> >>>
> >>>    The new cpumask conversions are going well, but unfortunately Stephen
> >>> uncovered a nasty bug via linux-next: the new cpumask operators only go to
> >>> nr_cpumask_bits which can be less than NR_CPUS if NR_CPUS > BITS_PER_LONG.
> >>> The undefined bits confuse the old cpumask operators.  We fixed one case,
> >>> but I am concerned that we will break archs as we convert more core code.
> >> Hi Rusty,
> >>
> >> I think we can avoid this problem if we make cpumask_bits == NR_CPUS iff
> >> CONFIG_CPUMASK_OFFSTACK=n.  This complies with the current cpumask_t
> >> approach and should cause all cpumask operators to always operate on
> >> all cpumask bits.
> > 
> > A very good point.  And it's no worse than the old method.
> > 
> > OK, forget about this for now, no urgent conversions needed :)
> > Rusty.
> 
> This probably should be submitted through linux-next for wider test coverage?

Identical patch already in series.

Thanks,
Rusty.
