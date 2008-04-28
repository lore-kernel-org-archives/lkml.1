Return-Path: <linux-kernel-owner+w=401wt.eu-S935403AbYD1SVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403AbYD1SVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:21:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbYD1SUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:20:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53491 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335AbYD1SUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:20:53 -0400
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Len Brown <lenb@kernel.org>, Matthew <jackdachef@gmail.com>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804231143.10875.maximlevitsky@gmail.com>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <200804182151.49021.lenb@kernel.org>
	 <200804231143.10875.maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 28 Apr 2008 20:19:44 +0200
Message-Id: <1209406784.11608.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 11:43 +0300, Maxim Levitsky wrote:
> On Saturday, 19 April 2008 04:51:48 Len Brown wrote:
> > On Friday 18 April 2008, Matthew wrote:
> > > Hi everyone, hi Linus,
> > > 
> > > congratulations on this new great kernel-release :)
> > > 
> > > I've another "regression" to report for 2.6.25:
> > > 
> > > it's concerning much higher temperatures being read out by the
> > > "coretemp" kernel-module in comparison to 2.6.24* series
> > > 
> > > e.g. where temperatures were around 40-47캜 they are now constantly
> > > jumping around 55-70캜 (even in idle !)
> 
> I just updated from 2.6.24 to 2.6.25
> (I usually follow whole development cycle, but I was very busy, so I skipped 2.6.25 cycle)
> 
> I confirm this.
> I *know* that temperatures reported now are wrong.

I too can confirm that it reports incorrect temperatures.

I have a Q9450, and this is my "sensors" output:
it8718-isa-0290
Adapter: ISA adapter
<snip>
temp1:       +44째C  (low  =  +127째C, high =  +127째C)   sensor =
thermistor
temp2:       +22째C  (low  =  +127째C, high =   +60째C)   sensor = diode
temp3:        -2째C  (low  =  +127째C, high =  +127째C)   sensor =
thermistor
vid:      +0.000 V

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +44째C  (high =  +100째C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +44째C  (high =  +100째C)

coretemp-isa-0002
Adapter: ISA adapter
Core 2:      +43째C  (high =  +100째C)

coretemp-isa-0003
Adapter: ISA adapter
Core 3:      +41째C  (high =  +100째C)


temp2 is the cpu temperature(matches bios), temp1 is the northbridge(i
think, bios says "system temp").

i have watercooling, and well :P when i touch the "tube", its normal
room temperature, and believe me, i would notice if it was 45.. this is
with my cpu at idle - at full load on all 4 cores, temp2 says 35, and
~60 on coretemp, and THIS i would surely be able to notice over room
temp :)

any progress on this bug?

> 
> The reason is that bios did report same temperatures as coretemp in 2.6.24,
> moreover some time ago I have run a cpu tool (don't remember its name) on windows
> which similar to coretemp reads from each core directly, sensor data , 
> and I noticed that temperature that bios reports is exactly the average 
> temperature of both cores
> (I had to run this on windows - intel haven't released 
> drivers for their QST for temperature monitoring from bios - very sad)
> 
> And the driver did say in kernel log that TJMAX is 85C
> 
> Lets at least make a kernel option to override tjmax?
> 
> Best regards,
> 	Maxim Levitsky
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

