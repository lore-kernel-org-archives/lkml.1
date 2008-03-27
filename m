Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbYC0SIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbYC0SIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYC0SIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:08:04 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:18839 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218AbYC0SIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ULwAfVGr1I9E6y8geC9RQCNJzsy/kaiXHRz6Y7xziFrHhDQEMTCzxX1UypMXZRc+QnpdIrl/NvLrAtmnORnBRXCnaCjwSYmH/ljb4JpmKuztkz8qO+CMvqTRnAR2R1M6/hMR7e0iKjEwJ561LMFeAer/nQXsJgZlBXzTnOgRQjM=
Message-ID: <86802c440803271107m4327554ct688738c80748d2d7@mail.gmail.com>
Date: Thu, 27 Mar 2008 11:07:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gary Hade" <garyhade@us.ibm.com>
Subject: Re: [PATCH] x86/pci: add pci=skip_isa_align command lines.
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080327175912.GA9684@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803270131.18885.yhlu.kernel@gmail.com>
	 <20080327084557.GH15626@elte.hu> <20080327175912.GA9684@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:59 AM, Gary Hade <garyhade@us.ibm.com> wrote:
>
> On Thu, Mar 27, 2008 at 09:45:57AM +0100, Ingo Molnar wrote:
>  >
>  > * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>  >
>  > > [PATCH] x86/pci: add pci=skip_isa_align command lines.
>  > >
>  > > so we don't align the io port start address for pci cards.
>  > >
>  > > also move out dmi check out acpi.c, because it has nothing to do with
>  > > acpi. it could spare some calling when we have several peer root
>  > > buses.
>  >
>  > i like this feature, and i've applied your patch to x86.git for testing,
>  > but i'd like to hear what the ACPI and PCI guys think about this.
>  >
>  > Also, we should try as hard as possible to make it a blacklist instead
>  > of a whitelist? It would be cool to support more PCI cards/devices on
>  > all new(-ish) systems by default and if we didnt have to maintain the
>  > DMI whitelist for eternity. (a whitelist will always be incomplete and
>  > will lag behind reality)
>
>  Ingo, This is a great idea.  I was the guy that added the whitelist
>  and ISA alignment avoidance code but have also been concerned about
>  the headache of keeping whitelist current in mainline and Distro
>  releases as new systems are introduced.  When I made the change I
>  assumed (appearently incorrectly) that there were way too many
>  existing systems requiring the alignment to even consider the
>  blacklist approach.  Do you have any suggestions on how to identify
>  systems to include in the blacklist? ...or would we just boldly make
>  non-alignment the default, provide an empty blacklist, and let
>  breakage identify those systems that need to be blacklisted?

at least to use blacklist with x86_64

YH
