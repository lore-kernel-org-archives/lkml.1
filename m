Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbXLOU0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbXLOU0x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 15:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXLOU0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 15:26:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbXLOU0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 15:26:45 -0500
Message-ID: <47643830.3000302@zytor.com>
Date: Sat, 15 Dec 2007 12:25:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80
 on some AMD64x2 laptops, etc.
References: <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <20071214131502.GA14359@elte.hu> <4762C551.5070003@zytor.com> <20071215074358.GD12110@elte.hu> <4763891A.3010004@gmail.com> <20071215132725.GA23166@elte.hu> <4763DE3F.405@gmail.com>
In-Reply-To: <4763DE3F.405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> 
> It's really going to have to be a known _un_used register and (the write 
> direction of) port 0x80 is used exactly for that reason. Port 0xed is a 
> known "alternate diagnostic port" used by Phoenix BIOSes at least but 
> Peter Anvin reported trouble with that one -- probably for the outb 
> direction but assuming that means something was in fact responding, we'd 
> have the same timing problem.
> 

Yes, for the outbound direction.

> I believe we have two "good" options:
> 
> 1) port 0xed was tested by the current reporter and found to be safe 
> (and provide slow enough timing). If DMI  based quirk hacks are 
> available soon enough we can switch 0x80 to 0xed based on it. Are they?

DMI is just a data structure parked in memory, so it should at least be 
theoretically possible to get to it.

	-hpa
