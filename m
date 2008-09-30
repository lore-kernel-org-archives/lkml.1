Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYI3UDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYI3UDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 16:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbYI3UCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 16:02:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:5686 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbYI3UCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 16:02:54 -0400
Message-ID: <ac3eb2510809301302l7d966896tfb0e3d230598974@mail.gmail.com>
Date: Tue, 30 Sep 2008 22:02:53 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Frans Pop" <elendil@planet.nl>
Subject: Re: CD tray closes spontaneously after opening it
Cc: "Tony Vroon" <tony@vroon.org>, linux-kernel@vger.kernel.org,
       "Tejun Heo" <tj@kernel.org>, "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <200809302150.38872.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809301247.05367.elendil@planet.nl>
	 <200809301447.35915.elendil@planet.nl>
	 <ac3eb2510809300655u319f8a9v58e4825f97ee329c@mail.gmail.com>
	 <200809302150.38872.elendil@planet.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 9:50 PM, Frans Pop <elendil@planet.nl> wrote:
> On Tuesday 30 September 2008, Kay Sievers wrote:
>> Does:
>>   /sbin/udevadm monitor --env
>> print something while you see the tray closing?
>
> I was somewhat lucky to reproduce it with that running and there was no
> output during the open or close. I guess that rules out udev?

I think so, yes.

> I still don't know how to reliably reproduce this. It seems that after it
> has occurred once, it will not occur again unless the system is rebooted.
> But I'm not 100% sure of that.
>
> Most times I've seen it was after playing a DVD when ejecting the disc to
> put it back in its box, but not when the DVD was inserted earlier.
> But I've also seen it shortly after the system is booted when just opening
> the tray with no media inserted.
>
> Just to be clear: until recently the drive has always behaved perfectly in
> the same situations.
>
>> Does this also happen when you set:
>>   /proc/sys/dev/cdrom/autoclose
>> to 0?
>
> I'll set that on boot using /etc/sysctl.conf and will report if I can
> still reproduce with that setting. I've checked that the "normal" value
> is 1.

That will prevent the closing, when something tries to open the device
in blocking mode. If that solves the issue, you should start looking
which process tries to access your drive.

Kay
