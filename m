Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbZKIPhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbZKIPhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZKIPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:37:55 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:47450 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZKIPhy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:37:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bam4uvP8hDFGRYur/Vp24Hy3c032ZQi0rv7Jj1IcrmnSEVI9sJE2lb/rSXxggXG0FN
         gaECRYIO7RxXd8lQCeKOCn00EYjCUuBRRiM1bRaCnHP5jJTEImg1l+YoJkflDD4P/Gr5
         dIgtnhpxr/JX+wDODJhStvXu4koKmtnTAawGM=
MIME-Version: 1.0
In-Reply-To: <20091107164830.GA1586@ucw.cz>
References: <90b950fc0911020050q3bc3fae8j954ec6ed73d79b5@mail.gmail.com>
	 <20091105192725.GE1392@ucw.cz>
	 <90b950fc0911070443s57d2ec5ehcb5c9cf9edcf8d8c@mail.gmail.com>
	 <20091107164830.GA1586@ucw.cz>
Date: Tue, 10 Nov 2009 00:37:59 +0900
Message-ID: <90b950fc0911090737tde32562qc878fac38cacabae@mail.gmail.com>
Subject: Re: [patch] added brightness feature to lcd class.
From: InKi Dae <daeinki@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kyungmin Park <kmpark@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

are you saying me that user shouldn't know if it is TFT-LCD or AMOLD?
I agree your saying.

if lcd class has brightness feature then sysfs file for controlling
brightness will be placed
in /sys/class/lcd/*/brightness.
it would be a problem because the path is no sysfs you expected.

how about that symbolic link file is created by lcd class for user?
like this,
/sys/class/lcd/*/brightness -> /sys/class/backlight/*/brightness

for this, some codes of creating symbolic link file should be added to
lcd class.

I still think it is not good way that lcd panel driver not having
backlight device has backlight driver
to control brightness and it should be solved in the course of time.

thank you.

2009/11/8 Pavel Machek <pavel@ucw.cz>:
> On Sat 2009-11-07 21:43:50, InKi Dae wrote:
>> Thank you for your comments.
>>
>> using backlight is good way in case of TFT-LCD Panel.
>> because TFT-LCD Panel needs backlight device to light up.
>>
>> but AMOLED LCD Panel doesn't need backlight device because lighting up itself.
>
> I know. So what?
>
> User wants to set brightness. Why should userspace know/care if it is
> TFT or AMOLED?
>
> I have this script:
>
> #!/bin/bash
> echo $1 > /sys/class/backlight/*/brightness
>
> why should I have to rewrite it just because you decided amoled is
> special?
>
> Kernel is expected to provide hw abstraction...
>
>                                                                        Pavel
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
