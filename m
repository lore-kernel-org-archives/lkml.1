Return-Path: <linux-kernel-owner+w=401wt.eu-S932379AbZKRVkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbZKRVkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 16:40:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932337AbZKRVks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 16:40:48 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48585 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbZKRVkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 16:40:47 -0500
MIME-Version: 1.0
In-Reply-To: <20091118213355.GA16630@srcf.ucam.org>
References: <ac3eb2510911170755i5188fb53ud2d6012a2db8c00a@mail.gmail.com> 
	<20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> 
	<20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> 
	<20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> 
	<20091118200712.GA14026@srcf.ucam.org> <ac3eb2510911181306g221e8940xfbcf8b8e7fa9a56e@mail.gmail.com> 
	<20091118213355.GA16630@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 18 Nov 2009 22:40:37 +0100
Message-ID: <ac3eb2510911181340q51fb91dcy24ac2f14e2899a4@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 22:33, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Nov 18, 2009 at 10:06:33PM +0100, Kay Sievers wrote:
>
>> That's true, but I think there is a significant difference between
>> polling every one or two seconds for media changes, and usually one or
>> two minutes for a disk idle. It's not that we poll in a rather hight
>> frequency, in an arbitrary interval, and check if some condition is
>> met.
>
> My use cases are on the order of a second.
>
>> I still don't think that we should add new event interfaces which are
>> single-subscriber only, and use global values for a specific user.
>> What if there will be another independent user for this, which might
>> want a different timeout? They fight over the trigger value to set in
>> sysfs?
>
> You can trivially multiplex without any additional wakeups. Something
> like devkit-disks can simply trigger on the lowest requested time and
> then schedule wakeups for subscribers who want a different timeout.

No, it can't do this race-free. And it's far from trivial. It can not
know when something changes the single global value.

Kay
