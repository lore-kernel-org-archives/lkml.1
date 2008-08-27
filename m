Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYH0Xmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYH0Xmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbYH0Xmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:42:33 -0400
Received: from outbound-mail-137.bluehost.com ([67.222.39.27]:39086 "HELO
	outbound-mail-137.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755872AbYH0Xmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:42:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=W8fy+8f5BGQnPVUQiT0NsXfy41Idn13yTh/NkBo8oDE1UFDpk52/6M/Rri1fC+IYPG9DVy2MIu+gtcWRCQ4ADpnxFO5UnNhysZ0MMqhSxjTWmFs3WBvP7OexwP95mbFo;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Date: Wed, 27 Aug 2008 16:42:25 -0700
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <914225.91320.qm@web82104.mail.mud.yahoo.com> <200808271541.11546.jbarnes@virtuousgeek.org> <86802c440808271623oc1ed5f1n8519fa7be9d1e301@mail.gmail.com>
In-Reply-To: <86802c440808271623oc1ed5f1n8519fa7be9d1e301@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271642.26486.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 27, 2008 4:23 pm Yinghai Lu wrote:
> On Wed, Aug 27, 2008 at 3:41 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> > On Monday, August 25, 2008 1:00 am Yinghai Lu wrote:
> >> On Mon, Aug 25, 2008 at 12:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> >> this one should work. please apply this one only.
> >> >>
> >> >> YH
> >> >>
> >> >> [PATCH] x86: check hpet with BAR v2
> >> >
> >> > - plus a more highlevel approach would be nice as well i think -
> >> > making sure that the hpet driver runs before any of the PCI code, and
> >> > inserting a special "sticky" resource there which would keep any
> >> > potential followup generic PCI resource that overlaps this resource
> >> > untouched. (with a proper kernel warning emitted as well - such
> >> > situations are likely BIOS bugs.)
> >>
> >> yes, can remove that late_initcall tricky code to insert resource for
> >> lapic and ioapic, and mmconfig etc.
> >
> > I agree, a higher level way of dealing with resource reservation might be
> > nice.
>
> 1. insert the lapic, ioapic, mmconf mmio address into resource tree at
> first... 2. later when we fail to request_resource for one BAR res of pci
> dev, call check_resource(.., res) to see if could find some res with the
> same range and the sticky flag.
> if so will insert BAR resource for the device forcibly.
>
> that should be for 2.6.28.
>
> > I'm hoping to polish up TJ's PCI allocation code
> > (http://tjworld.net/wiki/Linux/PCIDynamicResourceAllocationManagement)
> > for 2.6.28; it may have some stuff that can help.
>
> not sure. actually we should rely on BIOS to allocate ioport/mmio for
> us. and only do some minor adjust to BAR
> that is obvious wrong. so have list for gap seems overkilling.
> for Hotplug, the acpi code in dst should (pre)allocate the resource
> for new insert devices.

For just reservations that may be true, but we definitely want more space 
available for PCI device allocations.  As for ACPI allocations, maybe, but we 
have to make sure not to stomp on that space in the first place...
-- 
Jesse Barnes, Intel Open Source Technology Center
