Return-Path: <linux-kernel-owner+w=401wt.eu-S1763644AbYEAQbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763644AbYEAQbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYEAQax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:30:53 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:48797 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763405AbYEAQaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:30:52 -0400
Message-ID: <33216.75.164.221.130.1209659450.squirrel@clueserver.org>
In-Reply-To: <20080501160946.GA26089@elf.ucw.cz>
References: <4818D9AB.3040402@googlemail.com>
    <200805010157.58607.lenb@kernel.org>
    <20080501160946.GA26089@elf.ucw.cz>
Date: Thu, 1 May 2008 09:30:50 -0700 (PDT)
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to 
     ram
From: "Alan" <alan@clueserver.org>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Len Brown" <lenb@kernel.org>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi!
>
>> The ICH9 apparently provides a pair of memory mapped on-die thermal
>> sensors.
>>
>> The sensors basically shut off your hardware if it gets too hot.
>
> Are the sensors driven by ACPI? Probably yes, otherwise they would be
> unable to shut down the system.
>
>> ICH9 exports the base address for the sensors via a PCI device --
>> D31:F6, aka Linux 00:1f.6
>>
>> I'm not aware of a native Linux device driver that talks to this device
>> (nor can I think of a useful purpose for such a driver)
>> So it seems what is in play here is any BIOS code that talks to this
>> device,
>> and Linux's standard PCI config space restore.
>>
>> My guess is that the BIOS is enabling the device on cold boot,
>> but not enabling it after resume from S3.
>
> That sounds like a BIOS problem, right? If the piece of hardware is
> driven by BIOS, Linux can't be responsible for saving/restoring it.

I was having a similar problem on my old laptop. It seemed a lot more
sensitive to the problem on later kernels.

What was actually happening is that the last time the laptop went in for
repairs they did not seat the heat sink correctly.  It slowly worked
itself loose.  After regreasing it with heat sink grease (not a heat sink
pad, but actual silver grease) and reseating it and tightening it down,
the machine worked fine.  (I also found some nasty tool marks in the soft
metal next to the heat sink that shows that whoever did it slipped at
least once.)

Sometimes hardware problems increase slowly.

