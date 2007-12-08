Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXLHTuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXLHTuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbXLHTui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:50:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54518 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXLHTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:50:37 -0500
Date: Sat, 8 Dec 2007 20:50:35 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "David P. Reed" <dpreed@reed.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071208195035.GA22497@one.firstfloor.org>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <475AEF8E.5040906@reed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475AEF8E.5040906@reed.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 02:25:02PM -0500, David P. Reed wrote:
> 
> 
> Alan Cox wrote:
> >
> >0x80 should be fine for anything PC compatible anyway, its specifically
> >reserved as a debug port and supported for *exactly* that purpose by
> >many chipsets.
> >
> >  
> Disagree. The definitions of PC compatible are quite problematic.   I 
> have the advantage over some of you young guys, in that I actually wrote 
> code on one of the first 5 breadboard IBM PCs on the planet at Software 
> Arts, Inc. and I was directly involved in hardware spec projects with 
> the original IBM and Compaq engineers.  No one actually defined the port 
> numbered 80h as a "standard" for anything.  You won't find it documented 

It is a defacto standard for quite some time. Many motherboards
even come with builtin port 80 displays and port 80 cards are a standard
diagnostic tool. Pretty much all the of the standard BIOS
write diagnostic messages to port 80. While in theory a vendor
could change those BIOS they are pretty unlikely to do that.

Have you tried yet as someone asked earlier if using another 
free port that also leads to aborts causes the hang too?
If yes you would know for sure it is nothing on port 80,
but something not liking aborts (similar to the problem Eric B.
found earlier) 

Anyways using udelay is likely the way to go for modern
systems.

> Now the interesting thing is that I have been scanning the source code 
> of Linux, and I find gazillions of inb_p outb_p and so forth 
> instructions where they have NO value.   It's as if some hacker who half 

It is hard to know afterwards. In the past we definitely had systems
who needed such delays.  But some of it might be what you said.

-Andi
