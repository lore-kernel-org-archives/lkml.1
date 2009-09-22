Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbZIVBSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbZIVBSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 21:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbZIVBSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 21:18:45 -0400
Received: from mail-ew0-f213.google.com ([209.85.219.213]:62166 "EHLO
	mail-ew0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZIVBSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 21:18:44 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 21:18:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V48k4AmNws1+MIutPXLg7Ir3fOkVTkSnxf8j7WvKb+UaTRNbvQFt7PgB+orBV/Z5bo
         HmH00g3ZdRqs8YjutbsJIurAy1etdXf3y8A1+MIwPpiUsV79heGqOdYrps3JMJR51hVP
         +9PwfJG0hyO9IHf0PO39S5izME5E+dotzHMRE=
MIME-Version: 1.0
In-Reply-To: <20090921190434.GA10101@dreamland.darkstar.lan>
References: <4AB1C907.1070503@gmail.com>
	 <20090920162306.GA18214@dreamland.darkstar.lan>
	 <51f3faa70909201047x56313d99q7cdc49bcc4634b01@mail.gmail.com>
	 <20090920185824.GA23206@dreamland.darkstar.lan>
	 <51f3faa70909201551k70ace90x2b25351bfc04c555@mail.gmail.com>
	 <20090921190434.GA10101@dreamland.darkstar.lan>
Date: Mon, 21 Sep 2009 18:52:00 -0600
Message-ID: <51f3faa70909211752i29ab88b4kbf33278e171e3fd5@mail.gmail.com>
Subject: Re: asus_atk0110 not working on Asus P7P55D PRO
From: Robert Hancock <hancockrwd@gmail.com>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 1:04 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
> Il Sun, Sep 20, 2009 at 04:51:10PM -0600, Robert Hancock ha scritto:
>> On Sun, Sep 20, 2009 at 12:58 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> >> >> I'm guessing this board uses a different format than what the driver
>> >> >> is expecting. I'm attaching the gzipped decompiled DSDT from the
>> >> >> board, hopefully it's useful to somebody..
>> >> >
>> >> > Please try the following patch, it should detect the proper buffer size.
>> >> >
>> >>
>> >> Obviously something not quite right:
>> >
>> > Ah yes, the pointer for the output buffer was pointing to the wrong
>> > variable. Sorry for that ;)
>>
>> Cool, seems to be working.
>
> Excellent :)
>
>> Though the high and critical temperatures
>> seem a bit odd, but maybe that's what the BIOS actually reports:
> [...]
>> CPU Temperature:    +32.5°C  (high = +45.0°C, crit = +45.5°C)
>> MB Temperature:     +31.0°C  (high = +45.0°C, crit = +46.0°C)
>
> The limits are declared in the DSDT, the driver doesn't do any
> calculation.
> It's possible that Asus changed the encoding (again); so far I've been
> unable to locate a "version" field that would allow the driver to detect
> a change in the data structures.
>
> I've got a new patch for you: instead of probing and preallocating the
> buffer this version lets ACPI code do the allocation; the return value
> is cached anyway, so there won't be a big number of allocations.
> Can you please test and see if it works?

Yes, this version still works..
