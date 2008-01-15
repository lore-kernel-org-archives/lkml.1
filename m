Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYAOKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYAOKF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYAOKFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:05:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:44743 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYAOKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:05:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=b2sfkHxKvQJQfZB2pXubSSD4nYHN3awZBo9yviL8tw0fb3ia+ZzCL/nqNkp1iVXesBvF6k0Lg/ETG7EKo6WlEYlGZCPG/PxEsZHMSGxUZKIn9a2df4rDZX5ze2DupFZX+l/uIBQop0AnyXO/qwgUrnhgZbvzlQ0ZltzfjmMDYaE=
Subject: Re: [PATCH] [7/31] Extract page table dumping code from i386 fault
	handler into dump_pagetable()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, jbeulich@novell.com, mingo@elte.hu,
       tglx@linutronix.de
In-Reply-To: <200801151100.35927.ak@suse.de>
References: <200801141116.534682000@suse.de>
	 <20080114221639.31FC714F83@wotan.suse.de> <1200387377.16794.9.camel@brick>
	 <200801151100.35927.ak@suse.de>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 02:05:18 -0800
Message-Id: <1200391518.16794.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-15 at 11:00 +0100, Andi Kleen wrote:
> > > +void dump_pagetable(unsigned long address)
> > 
> > static?
> 
> This is used by other files too with future patches. Also
> in general it's useful for debugging stuff - i often put calls 
> to it into debugging patches.
> 
> > > +{
> > > +	typeof(pte_val(__pte(0))) page;
> > 
> > Is there any type that could be picked that would be nicer than
> > sprinkling ((__typeof__(page) *), typeof(pte_val(__pte(0))) etc
> > through here, I know it's just moving the code out to another
> > function, just wondering if you had any better ideas that someone
> > could follow-up on.
> 
> It could be pteval_t now which Jeremy recently introduced. But for pure
> code movement I don't want to do any improvements.

Sure, I had a very similar patch but was looking for a better way to
address this, I'll keep an eye on this and Jeremy's patch and follow
up when his stuff has settled a bit more.

Harvey

