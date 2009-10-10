Return-Path: <linux-kernel-owner+w=401wt.eu-S964897AbZJJUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897AbZJJUyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934813AbZJJUyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:54:19 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:55433 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814AbZJJUyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:54:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gv+d2Ib4OwsxRxh+nJXwNHqgTXzp6RetyyvJUVa0kXhIKrENU74n/b+sKu8kGqpH6y
         2BwLCSo0/uFfnSNcOOsf6JvFp5L5GmbSa9synvYEmdrGoiEtuDTD/kHcF6A+7aXZ7m00
         wtL2XQzYwRy8ZXuArbohG58ZECEkSG0Z8u5sI=
MIME-Version: 1.0
In-Reply-To: <20091010120448.GB1811@ucw.cz>
References: <1254669853.26496.0.camel@carter> <4AC8F02B.6080209@suse.de>
	 <200910042246.23712.rjw@sisk.pl> <4AC91578.2020807@suse.de>
	 <ca2dc2820910041455h18ece909rc2280a40f1899c0a@mail.gmail.com>
	 <4AC923F4.9050100@suse.de>
	 <ca2dc2820910041653o29d4b253n69270d231e56e447@mail.gmail.com>
	 <4AC93B45.8090707@suse.de>
	 <ca2dc2820910061005k2beae176lece9792bb15cda90@mail.gmail.com>
	 <20091010120448.GB1811@ucw.cz>
Date: Sat, 10 Oct 2009 22:53:39 +0200
Message-ID: <ca2dc2820910101353g65e4591ds82bf9fff8378abd4@mail.gmail.com>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 2:04 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > current full charge, when the charging is complete. It may end up lower or
>> > greater than
>> > previous value.
>> > Comparing current charge with the last full charge may correctly give you
>> >>100%.
>>
>> Then maybe we can write something like...
>>
>> val->intval = acpi_battery_is_charged(battery)
>>       ? min(battery->capacity_now, battery->full_charge_capacity) * 1000
>>       : battery->capacity_now * 1000;
>>
>> So we only use the min() operation when it is fully charged (returning
>> to 100%) without losing information when charging.
>>
>> The problem is that percentage may jump from >100% to 100% in
>> batteries whose full capacity increase, but I think that is OK, since
>> when completely charged, the >100% is the new 100%.
>>
>> In "broken" batteries (is it broken finally? or is it expected
>> behaviour?) like mine the old problem will be corrected, as it was
>> only present in the charged state.
>
> I believe you better work around this in userspace... or agree that
>>100% charge is possible.

I agree that >100% charge is possible while charging (because that
would mean the battery is over the last charged level); however, what
does it mean when charged?

In any case, my laptop's battery is not charging over 100% its
original capacity anyway, just reporting a wrong value.

>
>                                                                Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
