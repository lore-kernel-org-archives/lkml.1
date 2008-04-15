Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYDOH2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYDOH2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbYDOH2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:28:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:59666 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759933AbYDOH2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eCEhsPvoSKEJD+xn76RqFg1W/Is/qz+YyrbOJjHKLKJ3dsyOgqcAQhPkrYHISuvL5Bf15A0hF9jb1rkbwbN+UDI/f3f+8Ci1zEN6osDJgjGKl3DoQX9Jyo8RYP69i6k+PvdgV0sd/GW9bXYJPuvsFdOAqHmc7zJ6v0j4cQidMZA=
Message-ID: <86802c440804150028t33fabd7fn40d3d47d0482bfc1@mail.gmail.com>
Date: Tue, 15 Apr 2008 00:28:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080415001512.60cb784d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.704752615@symbol.fehenstaub.lan>
	 <87lk3hwv52.fsf@basil.nowhere.org>
	 <20080414232308.ffa4e269.akpm@linux-foundation.org>
	 <86802c440804150004w1c94b2dci520e0ffb8b60632f@mail.gmail.com>
	 <20080415001512.60cb784d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:15 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Tue, 15 Apr 2008 00:04:03 -0700 "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Mon, Apr 14, 2008 at 11:23 PM, Andrew Morton
>  > <akpm@linux-foundation.org> wrote:
>  > >
>  > > On Sun, 13 Apr 2008 18:56:57 +0200 Andi Kleen <andi@firstfloor.org> wrote:
>  > >
>  > >  > Johannes Weiner <hannes@saeurebad.de> writes:
>  > >  >
>  > >  > > Make free_bootmem() look up the node holding the specified address
>  > >  > > range which lets it work transparently on single-node and multi-node
>  > >  > > configurations.
>  > >  >
>  > >  > Acked-by: Andi Kleen <andi@firstfloor.org>
>  > >  >
>  > >  > This is far better than the original change it replaces and which
>  > >  > I also objected to in review.
>  > >  >
>  > >
>  > >  So...  do we think these two patches are sufficiently safe and important for
>  > >  2.6.25?
>  >
>  > the patch is wrong
>  >
>
>  The last I saw was this:
>
>
>  On Sun, 13 Apr 2008 12:57:22 +0200 Johannes Weiner <hannes@saeurebad.de> wrote:
>
>  > Hi,
>  >
>  > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>  >
>  > > On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
>  > > ...
>
> > >
>  > > could have chance that bootmem with reserved_early that is crossing
>  > > the nodes.
>  >
>  > Upstream reserve_bootmem_core() would BUG() on a caller trying to cross
>  > nodes, so I don't see where this chance could come from.
>
>  Is that what you're referring to?
>
>  Was Johannes observation incorrect?  If so, why?

my patch with free_bootmem will make sure free_bootmem_core only free
bootmem in the bdata scope.
so free_bootmem can handle the cross_node bootmem that is done by
reserve_early ( done in another patch, is dropped by you because took
Jonannes).

in setup_arch for x86_64 there is one free_bootmem that is used when
ramdisk is falled out of ram map. that could be crossed by bootloader
and kexec, and kernel or second kernel is memmap=NN@SS to execlue some
memory.

anyway that is extrem case, but my patch could handle that.

I wonder if any regression caused by my previous patch? maybe on other platform?

YH
