Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZDEIWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZDEIWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 04:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbZDEIW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 04:22:28 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:55832 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757471AbZDEIW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 04:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=xDrlL/xmTHBept8blbU6zwIV4O7g+9Bw1UKE42xw/UycZ3VL8eAVG2MO6rUxlKzOg6
         B5YAM+GH5ARPPoIXhoX/FvfsTc75H9GkRana6aGW3xF2Kzo6cVzVycBUkH1jCOYurRSX
         qV/iDYaD/lL5WIa6T3yKCtxkN9OzCMK9WueMM=
MIME-Version: 1.0
In-Reply-To: <504C592648%linux@youmustbejoking.demon.co.uk>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <71cd59b00904040133p1f130673r4e93d2c48f8f4616@mail.gmail.com>
	 <504C2315A8%linux@youmustbejoking.demon.co.uk>
	 <71cd59b00904040535t51f0e8bew34b487e0a3703f7e@mail.gmail.com>
	 <504C592648%linux@youmustbejoking.demon.co.uk>
Date: Sun, 5 Apr 2009 10:22:21 +0200
Message-ID: <71cd59b00904050122r626028c7y62a0cd44411e08b7@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Corentin Chary <corentin.chary@gmail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 5, 2009 at 12:10 AM, Darren Salt
<linux@youmustbejoking.demon.co.uk> wrote:
> I demand that Corentin Chary may or may not have written...
>
>>>> How can brn be -2?
>>> If notify_brn() wasn't called, it will be.
>
>> Oh, yeah, I miss the if() before notify_brn()
>
> Easily missed. ;-)
>
>>>> And why -2?
>>> Because notify_brn() won't return it (and if it ever does, it needs to be
>>> fixed). (Yes, I know, "magic numbers" and all that...)
>
>> Maybe a negative known error code could be used here
>
> I see the following:
>
> * read_acpi_int() returns 0 and writes the brightness setting to *val, or
>  returns -1 and writes -1 to *val if the ACPI call failed.
>
> * get_acpi() returns whatever was written to value by read_acpi_int(), or
>  -ENODEV if there's no ACPI method which can be called.
>
> * read_brightness is a trivial wrapper for get_acpi().
>
> * notify_brn() stores the result of read_brightness and returns the
>  previously-stored value, so it can store then later return -ENODEV, -1 or
>  the brightness setting.
>
> This makes -ENODEV a suitable value. Replacing that -1 with something other
> than -ENODEV might be good, but I don't think that that really matters right
> now (though I've replaced the "!= -1" in the original version of the patch
> with "< 0").
>
> Revised patch follows...

Thanks, it's cleaner now =).

There was just a little

ERROR: that open brace { should be on the previous line
#36: FILE: drivers/platform/x86/eeepc-laptop.c:521:
        if (bd)
+       {

But I corrected that. It is now pushed in acpi4asus tree.

-- 
Corentin Chary
http://xf.iksaif.net
