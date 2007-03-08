Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbXCHEBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbXCHEBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 23:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXCHEBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 23:01:13 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:53602
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbXCHEBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 23:01:12 -0500
Date: Wed, 7 Mar 2007 20:00:38 -0800
To: Paul Mackerras <paulus@samba.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [patch 2/6 -rt] powerpc 2.6.20-rt8: to convert spinlocks to raw ones.
Message-ID: <20070308040038.GA25351@gnuppy.monkey.org>
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi649d25qz.wl@toshiba.co.jp> <45EECE5C.6030100@ru.mvista.com> <17902.60669.945986.186995@cargo.ozlabs.ibm.com> <45EEF6A4.9090807@ru.mvista.com> <17903.4302.502364.126701@cargo.ozlabs.ibm.com> <45EF2CD8.3050804@ru.mvista.com> <17903.12035.781782.317694@cargo.ozlabs.ibm.com> <20070308004344.GA23200@gnuppy.monkey.org> <17903.33399.786962.498809@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17903.33399.786962.498809@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 02:26:47PM +1100, Paul Mackerras wrote:
> Bill Huey (hui) writes:
> 
> > The places that need to be reverted to raw spinlocks are generally either
> > acquired by function calls that allocate the spinlock at a terminal of the
> > kernel's lock graph or isolated from other callers completely (parts of the
> > timer for logic for instance). It's all about the collision of various lock
> > (preemptive and non-preemptive) subtrees and how to avoid scheduling within
> > atomic violations that lead to deadlocks. The -rt patch gets arbitrary
> > preemption abilities by shrinking the non-preemptive sub-tree bit to the bare
> > essentials of what will let a system to run yet still preserve all of
> > the expected locking semantics of a critical section.
> 
> Thanks; that's an interesting explanation.
> 
> It misses the point of what I was saying to Sergei, though, which was
> *not* "I don't understand your patch", it was "if this patch goes into
> a git tree, someone coming along in 3 years time won't understand the
> patch."  In other words I was ranting about the need for a decent
> description to accompany the patch itself, so it would go into the
> permanent record.

Yeah, I think it's a a fear and uncertainly about the technical details about
the patch. That is why folks CC Ingo and company to get either a kind of
confirmation that this is ok along with comments. There are very few folks
that really understand the basic principals of the patch in this community
and that's not going to change any time soon. The mystery, paranoia (FUD)
and criticism surrounding it can make folks a bit shy.

I'll talk to you and Ben about it if we all get to OLS again. :)

bill

