Return-Path: <linux-kernel-owner+w=401wt.eu-S1762034AbXEVBVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762034AbXEVBVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 21:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756390AbXEVBVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 21:21:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:32062 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXEVBVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 21:21:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lA3LUC/lXf/d08VHKJTxB7XlKY6vj/DKscgs+aRbee8eYVq8jGNQE2x8F526l1Ivly30Q9CFdONyuUV+dkIqyXsabhSBOKQulvyv+699+eiLovnEjKWOdPhEUVxUHcKVbNWhy/u5e0O3I4FgrVl7MnYPvmAJWpHdnx450use9q8=
Message-ID: <29495f1d0705211821r4200a1fft2b5c07a62b0620b1@mail.gmail.com>
Date: Mon, 21 May 2007 18:21:18 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: select(0, ..) is valid ?
Cc: "Anton Blanchard" <anton@samba.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Badari Pulavarty" <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au
In-Reply-To: <200705181521.34339.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com>
	 <Pine.LNX.4.64.0705151927360.28895@blonde.wat.veritas.com>
	 <20070516153703.GA26912@kryten> <200705181521.34339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 16 May 2007 17:37, Anton Blanchard wrote:
> > Hi Hugh,
> >
> > > It's interesting that compat_core_sys_select() shows this kmalloc(0)
> > > failure but core_sys_select() does not.  That's because core_sys_select()
> > > avoids kmalloc by using a buffer on the stack for small allocations (and
> > > 0 sure is small).  Shouldn't compat_core_sys_select() do just the same?
> > > Or is SLUB going to be so efficient that doing so is a waste of time?
> >
> > Nice catch, the original optimisation from Andi is:
> >
> > http://git.kernel.org/git-new/?p=linux/kernel/git/torvalds/linux-2.6.git;a=
> >commit;h=70674f95c0a2ea694d5c39f4e514f538a09be36f
> >
> > And I think it makes sense for the compat code to do it too.
>
> Yes agreed. I just forgot the copy'n'pasted code when doing the original
> change.

Is this headed upstream? It's causing some noise on test.kernel.org
now that SLAB is also warning about kmalloc(0).

Thanks,
Nish
