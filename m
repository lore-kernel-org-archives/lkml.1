Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYCaCky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYCaCky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbYCaCko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:40:44 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54551 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751330AbYCaCko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:40:44 -0400
Date: Sun, 30 Mar 2008 21:40:40 -0500
From: Jack Steiner <steiner@sgi.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] x86_64: Support for new UV apic
Message-ID: <20080331024039.GB20696@sgi.com>
References: <20080328191216.GA16455@sgi.com> <86802c440803301622j2874ca56t51b52a54920a233b@mail.gmail.com> <86802c440803301833r2229900cw99129515822dc373@mail.gmail.com> <20080331021224.GB20619@sgi.com> <86802c440803301923m29b6a0coca7f61975331cbe5@mail.gmail.com> <20080331022627.GE20619@sgi.com> <86802c440803301929k971c7a4m5f72aca1feca66c1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803301929k971c7a4m5f72aca1feca66c1@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2008 at 07:29:40PM -0700, Yinghai Lu wrote:
> On Sun, Mar 30, 2008 at 7:26 PM, Jack Steiner <steiner@sgi.com> wrote:
> >
> > On Sun, Mar 30, 2008 at 07:23:07PM -0700, Yinghai Lu wrote:
> >  > On Sun, Mar 30, 2008 at 7:12 PM, Jack Steiner <steiner@sgi.com> wrote:
> >  > > > >  Did you test it on non UV_X2APIC box?
> >  > >  >
> >  > >  > anyway the read_apic_id is totally wrong, even for your UV_X2APIC box.
> >  > >  > because id=apic_read(APIC_ID) will have apic_id at bits [31,24], and
> >  > >  > id |= __get_cpu_var(x2apic_extra_bits) is assuming that is on bits [5,0]
> >  > >  >
> >  > >  > so you even didn't test in your UV_X2APIC box!
> >  > >  >
> >  > >
> >  > >  It works fine on UV_X2APIX boxes because the double shift does
> >  > >  not occur. However, support for UV_X2APIC is dependent on
> >  > >  x2apic code that is not yet in the tree. Once the APIC
> >  > >  is switched into x2apic mode, the apicid is located in the LOW
> >  > >  bits of the apicid register, not the HIGH bits.
> >  >
> >  > oh, so that will need have new version GET_APIC_ID too.
> >
> >  Yes, although I think all the changes will be unified into
> >  one non-inline function that is a combination of
> >  GET_APIC_ID() & read_apic_id().
> 
> it seems x2apic patch should be applied before uv patch...
> 
> YH

That was the original plan but the x2apic code, although functional,
is not yet ready to be integrated. (This was mentioned as an
outstanding issue in the patch on Friday).

Once the x2apic patch is applied, there will be one additional
trivial UV patch (currently 1-line) that will be required to
make UV_X2APIX fully functional. Since the other 2 UV apic modes
are working right now, I decided not to wait for the x2apic patch
before submitting the patches for the basic UV infrastructure.

We have a lot of code that is queued up waiting for the
basic UV infrastructure to be integrated.


--- jack


