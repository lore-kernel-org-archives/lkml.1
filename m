Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZHJQOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZHJQOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbZHJQOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:14:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:46490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbZHJQOG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:14:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NvBnqaEZQ4GLp03l2wd1p7XvwL7iqJ2uJLsRdjImMS1pqdmMb/M2XLvBFpXB7+xnq
	PMrdF4Vy473DC7hxELOUg==
MIME-Version: 1.0
In-Reply-To: <20090810152825.GA4624@oksana.dev.rtsoft.ru>
References: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
	 <20090810150011.GA1471@ucw.cz>
	 <20090810152825.GA4624@oksana.dev.rtsoft.ru>
Date: Mon, 10 Aug 2009 09:14:01 -0700
Message-ID: <a55d774e0908100914h6a42546fk47cdb207628ebe5e@mail.gmail.com>
Subject: Re: power_supply class/framework question
From: Brian Swetland <swetland@google.com>
To: avorontsov@ru.mvista.com
Cc: Pavel Machek <pavel@ucw.cz>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 8:28 AM, Anton
Vorontsov<avorontsov@ru.mvista.com> wrote:
> On Mon, Aug 10, 2009 at 05:00:11PM +0200, Pavel Machek wrote:
>> > I'm working on cleaning up some code to more correctly use the power
>> > supply framework (have the battery driver receive notification from
>> > the wall/usb power supplies, etc), and ran into a slight snag.  For
>> > mobile usb powered devices, we need to know how much current can
>> > safely be consumed by the charge circuit -- generally this is one of:
>> > none, <500mA or 1000mA, which correspond to "no power supply", "usb
>> > power supply", or "wall power supply".
>>
>> Actuallly, it is one of 'none', 100mA (min power USB has to supplly),
>> 500mA (max powe USB can supply by spec), 1A (wall).
>>
>> > I can use power_supply_am_i_supplied() to determine if I'm receiving
>> > power, but there's no way to determine either how much (if I have one
>> > power supply that indicates max current available) or which supply (if
>> > I define a separate "ac" and "usb" power supply).
>>
>> Should am_i_supplied() just return miliamps?
>
> Or enum power_supply_type, with the following priority:
> mains (wall), usb, battery?

Either of those would work, though in the case of USB, as Pavel
correctly points out, we'd need to differentiate between
non-enumerated and enumerated, so perhaps max available milliamps
would be best.  Or USB could just not indicate that it's supplied
until after enumeration is successful.

Brian
