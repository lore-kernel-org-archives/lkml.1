Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbZHJQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbZHJQxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932270AbZHJQxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:53:46 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbZHJQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:53:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=tentcDX+hboWIzsSqz9m4oA5hFr+IvKznjErOJok5ZUGUlxEJFvIdSf4cisleKPmA
	BDSYk14CHOBNA6082AeEw==
MIME-Version: 1.0
In-Reply-To: <20090810163542.GC24947@sirena.org.uk>
References: <a55d774e0908071919s7b365f84o3baa19c8d6fbe899@mail.gmail.com>
	 <20090810150011.GA1471@ucw.cz>
	 <20090810152825.GA4624@oksana.dev.rtsoft.ru>
	 <a55d774e0908100914h6a42546fk47cdb207628ebe5e@mail.gmail.com>
	 <20090810163542.GC24947@sirena.org.uk>
Date: Mon, 10 Aug 2009 09:53:40 -0700
Message-ID: <a55d774e0908100953p561e8370r11e0b733b2097391@mail.gmail.com>
Subject: Re: power_supply class/framework question
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: avorontsov@ru.mvista.com, Pavel Machek <pavel@ucw.cz>,
       Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 9:35 AM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
>> > Or enum power_supply_type, with the following priority:
>> > mains (wall), usb, battery?
>
>> Either of those would work, though in the case of USB, as Pavel
>> correctly points out, we'd need to differentiate between
>
> I think we'll need to be able to report a list of supplies rather than
> just one - for example, a lot of battery operated devices will use a
> combination of USB and battery if the current draw exceeds what the USB
> supply is able to deliver.

Certainly -- though the case I'm dealing with the battery driver
wanting to know how much power is available upstream (via calling
am_i_supplied()) so it can decide if it can turn on the charger (and
if it should use low or highspeed charging).  The way I'm currently
handling this is that I have an "ac" supply (power brick) and a "usb"
supply, only one of which will be supplying power to the "battery"
supply (battery & charger).  In my case I'd never have multiple
upstream supplies active simultaneously, but I'm not sure if that'd
hold true for everyone.

Brian
