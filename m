Return-Path: <linux-kernel-owner+w=401wt.eu-S932280AbZKRUDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280AbZKRUDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:03:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbZKRUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:03:33 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:46240 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276AbZKRUDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <20091118195342.GA13627@srcf.ucam.org>
References: <1258468659-5446-1-git-send-email-mjg@redhat.com> 
	<ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> 
	<1258474180.16176.62.camel@localhost.localdomain> <20091117185742.GA19829@srcf.ucam.org> 
	<ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> 
	<20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> 
	<20091118195342.GA13627@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Nov 2009 21:03:21 +0100
Message-ID: <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 20:53, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 18, 2009 at 08:47:37PM +0100, Kay Sievers wrote:
>> On Wed, Nov 18, 2009 at 20:40, Matthew Garrett <mjg@redhat.com> wrote:
>> > On Wed, Nov 18, 2009 at 08:30:07PM +0100, Kay Sievers wrote:
>> >
>> >> Wouldn't it be good enough, if we add a file "idle_since" which
>> >> contains the time of the actual disk idle time, and userspace can
>> >> schedule a re-examination of that value at the actual end of the idle
>> >> time it is looking for?
>> >
>> > That would require either polling or waking up a userspace application
>> > on every disk access. Doing it in-kernel involves only a single timer
>> > wakeup for every active/idle transition.
>>
>> How would it? If you look for, like a 60 seconds timeout, and the file
>> contains 20, you schedule a wakeup in 40 seconds. If the file after
>> the 40 seconds contains 60, you reached your idle timeout exactly at
>> that moment, if it's less, then you re-calculate and start from the
>> beginning.
>
> How is that not polling? You'll repeatedly read a file looking for a
> value that may never appear - imagine the case where you're waiting for
> 60 seconds of idleness, but the disk always becomes active again after
> 50.

Sure, but what's wrong with reading that file every 50 seconds? Almost
all boxes poll for media changes of optical drives and usb card
readers anyway, so it's not that we are not doing stuff like this
already.

Kay
