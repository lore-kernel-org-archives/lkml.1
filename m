Return-Path: <linux-kernel-owner+w=401wt.eu-S964942AbZLHF1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942AbZLHF1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 00:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZLHF1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 00:27:19 -0500
Received: from smtp-out.google.com ([216.239.33.17]:41511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbZLHF1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 00:27:18 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=j6AGCmXDoqfHl6bTAHsEE+pXyy/eJNZNVloFqbrpHZ26qI5GAuNBy/y4B4W5k0ZUu
	R828avbwoui8kLLjpiWeQ==
MIME-Version: 1.0
In-Reply-To: <20091207165628.GA24981@rakim.wolfsonmicro.main>
References: <A6D19A13FE030A409EC4362C172E091F0E0495F6@eseldmw101.eemea.ericsson.se>
	 <20091204104930.GA28625@sirena.org.uk>
	 <A6D19A13FE030A409EC4362C172E091F0E071EB9@eseldmw101.eemea.ericsson.se>
	 <20091207114825.GA26965@rakim.wolfsonmicro.main>
	 <A6D19A13FE030A409EC4362C172E091F0E0A1FA1@eseldmw101.eemea.ericsson.se>
	 <20091207165628.GA24981@rakim.wolfsonmicro.main>
Date: Mon, 7 Dec 2009 21:27:20 -0800
Message-ID: <a55d774e0912072127u33cebd65xbfe341160c314a2e@mail.gmail.com>
Subject: Re: [POWER] battery calibration parameters from sysfs
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Rebecca Schultz Zavin <rebecca@android.com>,
       Mike Lockwood <lockwood@android.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, cbou@mail.ru,
       dwmw2@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       linux-embedded@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 7, 2009 at 8:56 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
>> One of the things we're facing is Android, which has
>> its userspace in plain Java JNI at the end of this link:
>> http://android.git.kernel.org/?p=platform/frameworks/base.git;a=blob;f=s
>> ervices/jni/com_android_server_BatteryService.cpp;h=8e7cadc6b680fc420d34
>> 1faa094c71922946fdab;hb=HEAD
>
> Something word wrapped that link but I think I found the same code.
>
>> If you browse down to line 275 you can see it parse the sysfs
>> attribute "capacity", then this propagates up to the battery
>> status indicator on *all* Android phones out there. So if
>> you want to run Android unmodified, this is what you need to
>> provide. They are effectively using the power sysfs as
>> their hardware abstraction layer in this case.
>
> Oh dear.  Using the power sysfs as the hardware abstraction seems
> perfectly reasonable but assuming that a given battery driver is going
> to have this level of information doesn't match up with an awful lot of
> actual charger hardware.  My main concern here is that battery
> performance monitoring has no pressing need to be in kernel and that
> pushing it into the kernel creates a barrier to implementing more
> advanced schemes in userspace, which is especially serious given how
> involved this needs to be in order to be accurate.

We should tidy up the userspace side to have better abstraction for
this.  On a number of devices we do obtain all the information
necessary from the kernel driver (or, in some cases battery monitoring
on the baseband side that the kernel driver chats with).  On other
devices we don't (Motorola Droid, for example uses a userspace battery
daemon).

>> Note: I'm not claiming that Android is doing it right or that
>> we can't modify this code or so, it's just that this is the way
>> a few million Android devices out there are actually doing it.
>
> I don't think the existing Android devices are much of an issue here,
> it's not as though end users have the ability modify the firmware on
> them (modulo the fairly small number of ADP devices).  This is an issue
> for people producing new devices who are already going to be doing some
> development to get the kernel up and running on their hardware.

My preference, from an Android point of view, would be to make sure we
have some reasonable userspace abstraction and provide a default
implementation that will do the right thing with an intelligent
battery driver (our usual design for inhouse work).  Then alternative
implementations can be plugged in, should that not be sufficient.

Brian
