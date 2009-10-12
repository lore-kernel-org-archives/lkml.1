Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbZJLUuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbZJLUuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZJLUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:50:17 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:59981 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755378AbZJLUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:50:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FALCt3+QjukyUn1Auam3Tnl0DoRZpJGa/4YlxClQcW+F4KkqJxEDwbVby/sTgdalNy82RbxW24QJfDCCZ5CyDMYYQqrHQHh0hWqFAqmx6nGZfKZ3vLrj1ZjI5Q0V5rDH;
Date: Mon, 12 Oct 2009 13:49:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Message-ID: <20091012134918.3246e06b@jbarnes-g45>
In-Reply-To: <20091012203453.GC7648@elte.hu>
References: <4AC97C00.7090503@kernel.org>
	<200910061133.27546.bjorn.helgaas@hp.com>
	<4ACB839A.2060800@kernel.org>
	<200910061257.54877.bjorn.helgaas@hp.com>
	<20091012203453.GC7648@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 22:34:53 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Tuesday 06 October 2009 11:51:22 am Yinghai Lu wrote:
> > > Bjorn Helgaas wrote:
> > > > On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
> > > >> for intel system with multi IOH. we could read peer root
> > > >> resource from PCI conf, and don't trust _CRS again for root bus
> > > > 
> > > > Ugh.  Are we going to end up with amd_bus.c, intel_bus.c,
> > > > nvidia_bus.c, broadcom_bus.c, serverworks_bus.c, etc.?
> > > only needed when you have muti ...
> > 
> > I think that translates to "yes, we will need all those bits as
> > soon as those vendors support larger systems with multiple IOHs."
> > And I think that's the wrong answer.
> 
> Why is having cleanly separated per vendor information/driver wrong?
> I think it's the right answer in most cases. _Especially_ when the
> other option is to 'rely on the firmware'.
> 
> > > again we should trust HW conf than BIOS.
> > 
> > Certainly there's a tradeoff between a generic driver that relies
> > on the BIOS, and a platform-specific driver that uses only the
> > hardware. The first leaves us vulnerable to BIOS bugs, but the
> > second leads to a plethora of drivers that require updates as
> > hardware changes.
> 
> We do that quite well in Linux - it's one of our main strengths.
> 
> Why should we have to rely on correct firmware? Why is it wrong to
> know about the hw's structure, to query the hardware and ignore the
> firmware if the hardware state tells us otherwise?

Right, I think the approaches are complimentary.  We want the hw info,
for cases where the fw is broken or there's no support for a given
configuration, but we also want the fw info for cases where we don't
yet have hw info (e.g. the bridge driver isn't updated) or it isn't
complete.

-- 
Jesse Barnes, Intel Open Source Technology Center
