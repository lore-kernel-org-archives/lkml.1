Return-Path: <linux-kernel-owner+w=401wt.eu-S1760694AbXEWWZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760694AbXEWWZl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 18:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760956AbXEWWZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 18:25:05 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:41144 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760924AbXEWWZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 18:25:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o/dVmhUrHmBlNt9zruixTiiuOu35d6pY3MW7VfXwGFKyEKeiykVpLnaBjzzxND9Ehl5ror5cG9fUo+ck8HXAWVYEr5u9VkUqkjMXQaexra/nrx9Yi+mKaHBnsGscRqiiab4JbsWcl+JxqHxnstJFmwyIK9YVwJOLefBVScykLb8=
Message-ID: <6bffcb0e0705231518l1a30e12cgbd66eafd45037661@mail.gmail.com>
Date: Thu, 24 May 2007 00:18:21 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc2-mm1
Cc: "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070523150122.f9946f37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	 <46540DB2.5000605@googlemail.com>
	 <Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	 <4654AC94.6080601@googlemail.com>
	 <20070523150122.f9946f37.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 23 May 2007 23:05:24 +0200
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Christoph Lameter napisa__(a):
> > > On Wed, 23 May 2007, Michal Piotrowski wrote:
> > >
> > >> Christoph, this looks like a bug in SLUB.
> > >
> > > Please boot with slub_debug to find the bad code that overwrites a slab
> > > object after it was freed.
> > >
> > >
> >
> > [   19.096577] Real Time Clock Driver v1.12ac
> > [   21.650315] *** SLUB kmalloc-8: Redzone Active@0xc90f6d20 slab 0xc528c530
> > [   21.657365]     offset=3360 flags=0x400000c3 inuse=61 freelist=0xc90f6d58
> > [   21.664349]   Bytes b4 0xc90f6d10:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> > [   21.674305]     Object 0xc90f6d20:  31 30 31 39 2e 30 30 35                         1019.005
> > [   21.684259]    Redzone 0xc90f6d28:  00 cc cc cc                                     .______
> > [   21.694265] FreePointer 0xc90f6d2c -> 0xc90f6d58
> > [   21.699061] Last alloc: get_modalias+0x61/0xf5 jiffies_ago=53 cpu=1 pid=554
> > [   21.706362]     Filler 0xc90f6d50:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ
>
> argh, I never 100% understood the slab gobbledygook, and now we have slub
> gobbledygook.  I _hope_ what that's saying is that the 00 at 0xc90f6d28
> wasn't supposed to be there.
>
> Obvious bug:
>
> --- a/drivers/firmware/dmi-id.c~a
> +++ a/drivers/firmware/dmi-id.c

Problem fixed. Thanks!

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
