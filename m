Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbZDVCJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbZDVCJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbZDVCJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:09:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:48622 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZDVCJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MNfJGycS/WNqhU1IEy4dOxyFRJP+hzDDGWlX2+satn/SmTu+iAYV22eaztbFXLaBWK
         9EZetoo8O6DCWc1CLKNq4rkoMAjTCoPHRLhYZwMitZ2LfQ7WPzVaNNl/ukQRpx3EPKv0
         I0L0ipnylj6YQnlq3bVyvH/AIh2USKYog6gdM=
MIME-Version: 1.0
In-Reply-To: <200904200952.34656.david-b@pacbell.net>
References: <49EC06A6.4040506@samsung.com> <200904200952.34656.david-b@pacbell.net>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Wed, 22 Apr 2009 11:09:27 +0900
Message-ID: <4d34a0a70904211909o430a4db3t61b7997a4124c3a1@mail.gmail.com>
Subject: Re: Suggestion on GPIO sysfs interface (gpio_export)
To: David Brownell <david-b@pacbell.net>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com, =?EUC-KR?B?uc66tMij?= <bhmin@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 1:52 AM, David Brownell <david-b@pacbell.net> wrote:
> On Sunday 19 April 2009, Kim Kyuwon wrote:
>> Can I ask you opinion about this idea?
>
> First issue:  labels aren't required to be unique, so
> there's a certain level of unpredictability you're
> introducing.  Exports using this new flag would fail
> sometimes depending on what *other* exports did.
> (That's part of the reason "gpio%d" names got used
> in the first place!)
>
> Another layer of unpredicatability comes from the
> way those strings are only available given debugfs.
>
>
> Second:
>
>> -extern int gpio_export(unsigned gpio, bool direction_may_change);
>> +extern int gpio_export(unsigned gpio, bool direction_may_change,
>> +                                                       bool label_may_show);
>
> It's generally confusing to add more parameters of the same type
> like that; there's no fundamental reason for people to remember
> which one means what, and the compiler can't help at all when (!)
> they get confused.

Thank you for pointing out problems :)

> Have you thought much about other options?  Like for example
> adding a new call.  With each MMC card slot, for one example,
> there would often be two GPIOs:  card_detect, write_protect.
> With two such slots, the "label" wouldn't be much help unless
> it were specifically made unique.
>
> Instead of exporting the GPIOs in a "flat" namespace, maybe
> something like
>
>  gpio_export_dev(struct device *dev, const char *tag,
>                unsigned gpio, bool direction_may_change);
>
> would be more useful.  It could gpio_export() the standard
> way, then set up a symlink using "tag" to set up a symlink
> from /sys/.../dev/tag to /sys/class/gpio/gpioN node.  Easy
> to see how that would work for those MMC examples.
>
> I can imagine there would be times when the GPIO doesn't
> have a logical coupling to any device, of course.  So maybe
> that doesn't address your particular issue.

Yes, we have a few devices which can be controlled by only 1 GPIOs. I
thought it is too small to make new drivers for these devices. So I
just tried to use gpio_export() function.
hmm.. I have to make do with new platform drivers for 1-GPIO controlled devices.
Anyway, thank you for your tip!

> - Dave
>

-- 
Kyuwon (±Ô¿ø)
