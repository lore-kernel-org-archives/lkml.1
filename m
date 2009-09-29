Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbZI2Oyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbZI2Oyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZI2Oya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:54:30 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:33571 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZI2Oya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:54:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GEFluFN5NRwRugD8r/GtWmZUe8WujyEmxB5udgxzBUuhwpe2zhVZJz+Q1QLTEPnPCP
         xANwD7kvlFhSd+2gjMcX/+WU3MCv23z1akD4xuK2+v+Iz7Hp5WX+cn4HH9xI9h0HbM9Q
         y5fcvF15tEC0pCxYyOj/eissh/duj3nZPaWcM=
MIME-Version: 1.0
In-Reply-To: <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
References: <20090923191240.GA15198@dreamland.darkstar.lan>
	 <51f3faa70909232018v7e621190m84deb648b08d2135@mail.gmail.com>
	 <20090928131700.GA19243@nb-core2.darkstar.lan>
	 <51f3faa70909281920x2782d8dfm1835ab24779abfa3@mail.gmail.com>
	 <51f3faa70909282134o1d60efekeded09f09b192df6@mail.gmail.com>
	 <68676e00909290707u70d192f2j2f2d4dd07bd07234@mail.gmail.com>
	 <51f3faa70909290740l4f4df186w114bf48e1db3a948@mail.gmail.com>
Date: Tue, 29 Sep 2009 16:54:33 +0200
Message-ID: <68676e00909290754o433cb3e7mea8c6e4931934f8d@mail.gmail.com>
Subject: Re: [PATCH] asus_atk0110: add support for Asus P7P55D
From: Luca Tettamanti <kronos.it@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 4:40 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Tue, Sep 29, 2009 at 8:07 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>>> Hi Robert,
>>>>> I have a new patch for you :)
>>>>> It contains the previous changes to handle the bigger ASBF buffer plus a new
>>>>> method to enable the EC as suggested by Asus. Be sure to compile with
>>>>> HWMON_DEBUG_CHIP enabled.
>>>>
>>>> Excellent.. seems to work now and give actually updating sensor readings :-)
>>>
>>> Have seen a couple of these though, looks like about once an hour:
>>>
>>> ACPI Exception: AE_TIME, Returned by Handler for [EmbeddedControl]
>>> (20090903/evregion-424)
>>> ACPI Error (psparse-0537): Method parse/execution failed
>>> [\_SB_.PCI0.SBRG.ASOC.GIT6] (Node ffff88013ba778c0), AE_TIME
>>> ACPI Error (psparse-0537): Method parse/execution failed
>>> [\_SB_.PCI0.SBRG.ASOC.GITM] (Node ffff88013ba6ea40), AE_TIME
>>> ATK0110 ATK0110:00: atk_read_value_new: ACPI exception: AE_TIME
>>>
>>> Maybe sometimes the embedded controller takes longer than the timeout
>>> to process, or something?
>>
>> Is there a message like "input buffer is not empty" before that?
>
> Nope, that's all I'm getting each time it happens. Suggestions/debug
> patches welcome..

drivers/acpi/ec.c:30, uncomment "#define DEBUG"
Next step would be rising the timeouts and/or retry count in ec_poll
(will ask support from ACPI gurus...)

L
