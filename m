Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZAJSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZAJSFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZAJSF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:05:26 -0500
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:40084 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZAJSFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:05:25 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4968E365.5040409@gmail.com>
Date: Sat, 10 Jan 2009 18:05:25 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@sirena.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@kernel.org>
Subject: Re: Regulator: Use case query (many devices need to reg their voltage
 requirements?)
References: <4968BE74.1070903@gmail.com> <20090110174602.GA31525@sirena.org.uk>
In-Reply-To: <20090110174602.GA31525@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
>   
>> A number of different embedded system now use main boards (core etc) in
>> conjunction with daughter boards.  In these cases different modules may
>> be inserted to support different daughter board options from a single kernel
>> (and combinations if possible).  Thus we have a situation in which the
>> appropriate voltage level can only be established if the various drivers
>> specify what they need. The board config may specify numerous devices
>> only some of which may actually be present.
>>     
>
> The wide range of plug in and subfit options isn't that unusual.
> There's quite a few modular reference designs out there, including
> designs where the power module is replacable.
>
> When I've considered this in the context of designs I've worked on in
> the past I've always thought it would be easiest to represent the plug
> in modules in the device tree with the main board regulators being set
> up to know only about the supplies they provide to the board.  The plug
> in boards could then map how those supplies are distributed within the
> boards, using virtual regulators to pass through the supplies from the
> main board and being able to supply board-wide requirements for the
> design.
>   
That's sounds like a sensible approach, though not entirely sure how it
will work out in
practice.  Guess there is only one way to find out!
> I've not actually tried doing this so I've not had a chance to run into
> any practical problems with it yet, and I'm not sure how well it maps
> onto your system.
>   
It maps fine, particularly as quite a few daughter boards have local (be
it static)
regulators to ensure clean supplies etc.
>> This leads to additional complexity in numerous drivers as they have to act
>> as dynamic drivers (terminology from regulator docs) even though they don't
>> actually vary the voltage, merely specify what ranges they can work with.
>>     
>
> For simple cases it's only one function call, though power requirements
> often depend on other system considerations such as clock rates and
> analogue design.
Sure, I guess in cases where the requirements are board specific rather
than driven by the chip, some
means of overriding the defaults may be necessary.  Not something that
we will want to add to drivers
unless actually needed.
>   There will also be issues if the drivers are for chips
> which have multiple software compatible variants with differing power
> requirements.
>   
Yup, though in many cases they have different part numbers etc and can
be handled via multiple
driver registrations or alias provisions such as in i2c.  This is how
things like adc's with differing
numbers of inputs depending on precise model are handled anyway.
>   
>> Is this the best way to handle this situation, or do people have other
>> suggestions?
>>     
>
> Does the above idea work for you?
>   

I think so. Guess it's going to be a case of trying out an example and
seeing how it goes.

Thanks,

Jonathan

