Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYC3VEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYC3VEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYC3VEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 17:04:01 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52683 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753343AbYC3VEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 17:04:01 -0400
Date: Sun, 30 Mar 2008 16:03:56 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Message-ID: <20080330210356.GA13383@sgi.com>
References: <20080324182122.GA28327@sgi.com> <87abknhzhd.fsf@basil.nowhere.org> <20080325175657.GA6262@sgi.com> <20080326073823.GD3442@elte.hu> <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301323q5c4bd4f4k1f9bdc1d6b1a0a7b@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 01:23:12PM -0700, Yinghai Lu wrote:
> On Wed, Mar 26, 2008 at 12:38 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  * Jack Steiner <steiner@sgi.com> wrote:
> >
> >  > > > -        obj-y                            += genapic_64.o genapic_flat_64.o
> >  > > > +        obj-y                            += genapic_64.o genapic_flat_64.o genx2apic_uv_x.o
> >  > >
> >  > > Definitely should be a CONFIG
> >  >
> >  > Not sure that I understand why. The overhead of UV is minimal & we
> >  > want UV enabled in all distro kernels. OTOH, small embedded systems
> >  > probably want to eliminate every last bit of unneeded code.
> >  >
> >  > Might make sense to have a config option. Thoughts????
> >
> >  i wouldnt mind having UV enabled by default (it can be a config option
> >  but default-enabled on generic kernels so all distros will pick this hw
> >  support up), but we definitely need the genapic unification before we
> >  can add more features.
> 
> config option would be reasonable.
> for x86_64
> subarch already have X86_PC, X86_VSMP.
> we have X86_UVSMP

If there was a significant differece between UV and generic kernels
(or hardware), then I would agree. However, the only significant
difference is the APIC model on large systems. Small systems are
exactly compatible.

The problem with subarch is that we want 1 binary kernel to support
both generic hardware AND uv hardware. This restriction is desirable
for the distros and software vendors. Otherwise, additional kernel
images would have to be built, released, & certified.

--- jack

