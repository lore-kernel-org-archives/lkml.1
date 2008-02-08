Return-Path: <linux-kernel-owner+w=401wt.eu-S964844AbYBHS1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844AbYBHS1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935214AbYBHS0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:26:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33097 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864AbYBHS0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:26:34 -0500
Date: Fri, 8 Feb 2008 20:01:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Message-ID: <20080208190143.GB11573@one.firstfloor.org>
References: <20080207195519.GA21772@basil.nowhere.org> <200802081613.39906.prakash@punnoor.de> <20080208160906.GA9642@one.firstfloor.org> <200802081839.18267.prakash@punnoor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802081839.18267.prakash@punnoor.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 06:39:17PM +0100, Prakash Punnoor wrote:
> On the day of Friday 08 February 2008 Andi Kleen hast written:
> > On Fri, Feb 08, 2008 at 04:13:35PM +0100, Prakash Punnoor wrote:
> 
> > > Sorry, I meant the opposite. I needed the acpi_skip_timer_override kernel
> > > parameter for nforce2, thus no override. So this chipset is missing here.
> > > At least I remember that my nforce2 needed the skipping,
> >
> > I hope you remember correctly and mean it this time. It would be better
> > if you could double check.
> 
> Yes, confirmed. timer w/o the skipping stays XT-PIC on nforce2.

Confirmed what? Did you test my patch on both machines? 
What was the result? 

> lspci -n:

Please always send lspci without -n too; I hate looking up hex codes
by hand when a computer can do that for me.

> 02:00.0 0300: 10de:0281 (rev a1)
> 
> > I'm a little sceptical because we had this patch in OpenSUSE 10.3
> > and I didn't think there were complaints from NF2 users.
> > With the changes you're requesting it turns from something
> > very well tested into something experimental.
> 
> Well, even w/o the skipping my nforce2 system wasn't unstable, AFAIK. So I 
> don't think just because of the XT-PIC entry people would complain.

Timer override only does something in APIC mode and when you see XT-PIC
in /proc/interrupts then you're not in APIC mode. All these patches
are a no-op in this state.

> See why I don't want the quirk to be applied more than needed? *NOT* applying 
> the quirk on nforce2 didn't cause any obvious side effects. APPLYING to mcp51 
> causes hard lock-ups.

Can you please just test the patches instead of speculating what they
might do or not do?

-Andi
