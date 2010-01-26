Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418Ab0AZBMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab0AZBMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 20:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892Ab0AZBMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 20:12:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43553 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0AZBMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 20:12:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RS1K42HfviGQ+aiOHlebT7g614AbdyEGdBG62c2D3hk7ptEBpLS5xQU0780squ7NqK
         uHuSi/HbTCY6kAkk//4m/maaz2ZVKUZd+mFlM3SkysGlLky5HXloiaU3UNlUW8uYBFMT
         QCbvBOWLCi/GYnM2+tdXrTDJg8mYDmOMkzYOo=
Date: Tue, 26 Jan 2010 02:12:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       rusty@rustcorp.com.au, akpm@linux-foundation.org, ebiederm@xmission.com,
       tytso@mit.edu, Trond.Myklebust@netapp.com, aelder@sgi.com,
       hch@infradead.org, viro@zeniv.linux.org.uk, davem@davemloft.net,
       netdev@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
       dan.j.williams@intel.com, borislav.petkov@amd.com, ying.huang@intel.com,
       lenb@kernel.org, neilb@suse.de, cl@linux-foundation.org
Subject: Re: [PATCH 7/8] percpu: add __percpu sparse annotations to
	hw_breakpoint
Message-ID: <20100126011234.GL5087@nowhere>
References: <1264432935-10453-1-git-send-email-tj@kernel.org> <1264432935-10453-8-git-send-email-tj@kernel.org> <20100126001901.GI5087@nowhere> <4B5E401D.2020809@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E401D.2020809@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 05:06:37PM -0800, H. Peter Anvin wrote:
> On 01/25/2010 04:19 PM, Frederic Weisbecker wrote:
> > On Tue, Jan 26, 2010 at 12:22:14AM +0900, Tejun Heo wrote:
> >> Add __percpu sparse annotations to hw_breakpoint.
> >>
> >> These annotations are to make sparse consider percpu variables to be
> >> in a different address space and warn if accessed without going
> >> through percpu accessors.  This patch doesn't affect normal builds.
> >>
> >> per_cpu(nr_task_bp_pinned, cpu) is replaced with
> >> &per_cpu(nr_task_bp_pinned[0], cpu).  This is the same to the compiler
> >> but allows per_cpu() macro to correctly drop __percpu designation for
> >> the returned pointer.
> > 
> > Ouch... It's unpleasant to see such workaround that messes up the
> > code just to make sparse happy.
> > 
> > I guess __percpu is an address_space attribute? Is there no
> > way to force the address space change directly from the
> > per_cpu() macro?
> > 
> 
> Hmm... thinking more about it, we should be able to just move the & and
> [0] into the per_cpu() macro, addressing the situation, or does that
> cause problems elsewhere?
> 
> 	-hpa


That would work only with arrays. per_cpu() can access either pointers
or direct values. Well that can be worked around with fake casts, but
I would except the (typeof(x) __force) to work and then offer a more
elegant solution.

