Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZCaJVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZCaJVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZCaJVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:21:01 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39605 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZCaJVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:21:00 -0400
Subject: Re: [RFC PATCH 0/3] GPIO switch framework
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Ben Nizette <bn@niasdigital.com>
Cc: "david-b@pacbell.net" <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "juha.yrjola@solidboot.com" <juha.yrjola@solidboot.com>
In-Reply-To: <1237703121.2720.39.camel@linux-51e8.site>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
	 <1237703121.2720.39.camel@linux-51e8.site>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 12:18:58 +0300
Message-Id: <1238491138.5936.86.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2009 09:19:58.0699 (UTC) FILETIME=[DCCD9BB0:01C9B1E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben, and thanks for your feedback.

On Sun, 2009-03-22 at 07:25 +0100, ext Ben Nizette wrote:
> On Fri, 2009-03-20 at 15:50 +0200, Jani Nikula wrote:
> > Hi -
> > 
> > This RFC patchset is a pretty straightforward adaptation of OMAP GPIO
> > switch framework for mainline integration.
> > 
> > The GPIO switch framework allows reporting and changing GPIO switches
> > via sysfs, with debouncing and sysfs/in-kernel notifications for input
> > switches.
> 
> OK, so what does this do that /sys/class/gpio/gpioN doesn't currently do
> apart from debouncing?  And the output being a string rather than a
> simple value (which IMO might be better suited to userspace
> interpretation anyway).

In addition to debouncing, there's sysfs and in-kernel notifications.

To hide potential changes in hardware from userspace, there's naming of
the sysfs entries (e.g. /sys/class/gpio/switch-foo) and a flag for
inverting the value.

> I've got a patch, little abandoned at the bottom of my queue, which adds
> poll(2) compatibility to the gpiolib sysfs entries [1] and extending
> this patch to do debouncing as well would be almost trivial.

Your patch certainly looks promising, and indeed overlaps with my work.
Debouncing could be easily added, and perhaps symbolic links to provide
names for the switches.

However, if I didn't miss anything, your patch allows setting up the
notification through sysfs only, and there's no way of doing it from
kernel side. Also, I'd need debounced callback notifications.

> I guess what I'm getting at is that this seems like it solves a problem
> which has been pretty much solved elsewhere since the OMAP boys wrote
> this.

It's been only partially solved by your patch, and as you say yourself,
it's still at the bottom of your queue. There's also the gpio-keys
(pointed out by Philipp Zabel elsewhere in this thread), but that's
input only and lacks in-kernel notifications. AFAIK the input layer is
also pretty fixed in what can be reported. So I am not convinced this
has been solved elsewhere.

Do you have any plans to resume work on your patch?


BR,
Jani.


> 	--Ben.
>  
> [1] http://marc.info/?l=linux-kernel&m=122454305213792&w=2


