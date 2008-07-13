Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYGMV1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYGMV1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYGMV06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:26:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:25704 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYGMV05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mY9Vd4l/azOE+R/JrTE7/5Q1A0LPS7PHaEZZgV89i3YvSrBMVU2slqebpbVLRPoDLD
         N9kMnzOYnAOFmfuhmJbi1wY3OZo7eMYs6mBNtnJjoNKk0AGAO1lm6VcG+nQq53uiGezY
         QnMiFR9TrHDVNmjivFUOzTeJYoq50ubnuog8g=
Message-ID: <4dfa50520807131426t4013142cp1fcd49e078a79c1f@mail.gmail.com>
Date: Sun, 13 Jul 2008 15:26:56 -0600
From: "David Hubbard" <david.c.hubbard@gmail.com>
To: "Hans de Goede" <j.w.r.degoede@hhs.nl>
Subject: Re: [lm-sensors] [RFC] (almost) booting allyesconfig -- please don't poke super-io without request_region
Cc: "Jean Delvare" <khali@linux-fr.org>, linuxppc-dev@ozlabs.org,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Milton Miller" <miltonm@bga.com>, lm-sensors@lm-sensors.org
In-Reply-To: <487A7211.7030309@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <for-27-patch1-0@bga.com> <48768018.2070704@hhs.nl>
	 <acca8e14e769b2feadee19f1f7448438@bga.com>
	 <20080711085246.1ead773b@hyperion.delvare> <48770B5E.7000308@hhs.nl>
	 <20080711093650.4b98e3b7@hyperion.delvare> <4879A144.8060203@hhs.nl>
	 <4dfa50520807131411ied883cgcb20eb6bd94f761@mail.gmail.com>
	 <487A7211.7030309@hhs.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans,

>> I propose writing a subsystem driver. (Is that properly called "The
>> SuperIO Bus Driver"?) If no one thinks it's a really bad idea I will
>> put together some code and submit it for review, and maintain it.
>>
>> Some hwmon chips have odd / unique probe sequences. IMHO this is where
>> the design needs to be inspected. One of those is the w83627ehf, which
>> Jean and Hans are familiar enough with to check my work.
>>
>> Thoughts?
>
> I'm afraid that making this a "bus" will be a bit overkill. Jim's patches
> are quite simple and seem todo the job.
>
> Also keep in mind that most users will be platform devices which just want
> to use the superio registers to find out the baseaddress of their logical
> device, a whole bus seems overkill for this, would the hwmon driver then
> need to be a superio_driver (as well as an platform_driver) or can the bus
> be queried / used
> without having to be a bustype-driver?

I think that's a valid point. I am willing to keep it small, but I
would prefer to follow the pattern set in other subsystems. It may be
my lack of experience in designing a subsystem showing here! What are
some alternative ways to implement it?

In other words, Jim's patches are a good start, but maybe I am
misunderstanding them. I see it as the superio-locks module, a driver
that other drivers would depend on / auto-load. Is that something
other subsystems also do?

Regards,
David
