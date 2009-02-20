Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZBTLQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZBTLQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 06:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZBTLQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 06:16:45 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:63406 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZBTLQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 06:16:44 -0500
MIME-Version: 1.0
In-Reply-To: <20090220094356.GB26124@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
Date: Fri, 20 Feb 2009 12:16:42 +0100
Message-ID: <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
Subject: Re: General question (scheduler) with SSDs?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 10:43, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> Whoops, I didn't mean to send that previous half formed mail :) Sorry.
>
> On Thu, Feb 19, 2009 at 08:38:38AM -0500, Justin Piszcz wrote:
>>
>> I was curious if anyone had done any benchmarks and/or has conclusive
>> information, what is the best Linux scheduler to use with SSDs?
>>
>> Noop?
>> CFQ?
>> AS?
>> Deadline?
>
> As mentioned in another mail there was a discussion on
> http://lkml.org/lkml/2009/1/31/28 and long thread talking about the
> introduction of the rotational flag here
> http://lkml.org/lkml/2009/1/5/340 . Cheapo SSDs or even USB keys are not
> auto detected as non-rotational devices by the kernel and after a bit of
> poking about I've come up with the following udev rules for my
> particular cases:
>
> SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{model}=="ASUS-PHISON *", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"

Udev can write to the attribute itself. This should be all you need:
  SUSBSYTEM=="block", ATTRS{model}=="ASUS-PHISON *", ATTR{queue/rotational}="1"

Kay
