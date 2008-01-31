Return-Path: <linux-kernel-owner+w=401wt.eu-S934022AbYAaVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022AbYAaVmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 16:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759751AbYAaVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 16:42:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:46583 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760032AbYAaVmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 16:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h7UcaT9gYnGeYsGgxFiZBC41Da5MYqSpjyBEvufhG2da6i3aFZDw4M8I/NjLWfI8iJfjuPrKgzttKthHYM/2txvSq+jJ3Cfte6EkkdPqgRQK0dCVF3Sbn8thpsx6Fa4c4u7+7t/Kk0X/61i6fWVhRyVDXE6qrk+JuWk3nEktjQo=
Message-ID: <86802c440801311342y16ff7c7eib28bf1c576be7075@mail.gmail.com>
Date: Thu, 31 Jan 2008 13:42:03 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>
Subject: Re: Purpose of numa_node?
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>, "Paul Mundt" <lethal@linux-sh.org>,
       "Chris Snook" <csnook@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47A23F1C.7080809@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47A11ACD.1090400@redhat.com> <20080131074045.GA13788@linux-sh.org>
	 <47A1D03A.3020508@inria.fr>
	 <86802c440801311329h67a79139xa33994e2cc116781@mail.gmail.com>
	 <47A23F1C.7080809@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 31, 2008 1:35 PM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Yinghai Lu wrote:
> > On Jan 31, 2008 5:42 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> >
> >> It works fine on regular machines such as dual opterons. However, I
> >> noticed recently that it was wrong on some quad-opteron machines (see
> >> http://marc.info/?l=linux-pci&m=119072400008538&w=2) because something
> >> is not initialized in the right order. But I haven't tested 2.6.24 on
> >> this hardware yet, and I don't know if things have changed regarding this.
> >>
> >
> > that will depend if you dsdt have _PXM for your pci root bus.
> > otherwise you will get all -1
> >
>
> Have a look at the above link. I don't get -1. I get 0 everywhere, while
> I should get 1 for some devices. And if I unplug/replug a device using
> fakephp, numa_node becomes correct (1 instead of 0). This just looks
> like the code is there but things are initialized in the wrong order.

do you have
...
bus 00 -> pxm 0 -> node 0
...
bus 40 -> pxm 1 -> node 1
...
bus 80 -> pxm 1 -> node 1

in your boot msg or dmesg?

if not, your dsdt doesn't have _PXM for pci root bus. or you need to
ask your HW vendor to add that in their BIOS, or use my patchset.

YH
