Return-Path: <linux-kernel-owner+w=401wt.eu-S1753709Ab0ADWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab0ADWpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801Ab0ADWpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:45:45 -0500
Received: from ozlabs.org ([203.10.76.45]:53089 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab0ADWpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:45:44 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: kprobes: get rid of distinct type warning
Date: Tue, 5 Jan 2010 09:15:41 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com> <20091230132945.f32f49fd.akpm@linux-foundation.org> <20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100104155702.GB5671@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001050915.41334.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 02:27:02 am Heiko Carstens wrote:
> On Wed, Dec 30, 2009 at 01:29:45PM -0800, Andrew Morton wrote:
> > On Mon, 21 Dec 2009 13:02:24 +0100
> > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > 
> > > Of course the patch wouldn't help for CONFIG_PREEMPT and !CONFIG_SMP since
> > > we would have a comparison of a signed and and unsigned value again *sigh*.
> > 
> > We should fix that, shouldn't we?  Rather than working around it at one
> > caller site.
> > 
> > : #if NR_CPUS > 1
> > : #define num_online_cpus()	cpumask_weight(cpu_online_mask)
> > : #define num_possible_cpus()	cpumask_weight(cpu_possible_mask)
> > : #define num_present_cpus()	cpumask_weight(cpu_present_mask)
> > : #define num_active_cpus()	cpumask_weight(cpu_active_mask)
> > : #define cpu_online(cpu)		cpumask_test_cpu((cpu), cpu_online_mask)
> > : #define cpu_possible(cpu)	cpumask_test_cpu((cpu), cpu_possible_mask)
> > : #define cpu_present(cpu)	cpumask_test_cpu((cpu), cpu_present_mask)
> > : #define cpu_active(cpu)		cpumask_test_cpu((cpu), cpu_active_mask)
> > : #else
> > : #define num_online_cpus()	1
> > : #define num_possible_cpus()	1
> > : #define num_present_cpus()	1
> > : #define num_active_cpus()	1
> > : #define cpu_online(cpu)		((cpu) == 0)
> > : #define cpu_possible(cpu)	((cpu) == 0)
> > : #define cpu_present(cpu)	((cpu) == 0)
> > : #define cpu_active(cpu)		((cpu) == 0)
> > : #endif
> > 
> > The num_*() "functions" return unsigned on SMP and int on UP.  This is
> > wrong.
> > 
> > The cpu_*() "functions" got lucky and return int in both cases.
> > 
> > Personally I think it's neatest if a quantity which can never be
> > negative is held in an unsigned type.  Than includes anything starting
> > with "num".  But for expediency's sake we could live with making these
> > things consistently return "int".
> > 
> > Alas, changing those four num_*() "functions" to return int on SMP is a
> > pretty wide-reaching change and will probably expose warts.
> 
> Looks like there are quite a lot of num_* function usages in the kernel.
> Some seem to assume they return an int some assume an unsigned int.
> Don't know if it's worth changing anything here.
> Maybe Rusty has an opinion.

If we have to go one way or the other, go with unsigned.

What does such a patch look like?

Thanks,
Rusty.
