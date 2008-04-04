Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbYDDDjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbYDDDjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 23:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYDDDi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 23:38:58 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:45974 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYDDDi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 23:38:58 -0400
Date: Thu, 3 Apr 2008 20:33:09 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Ben Nizette <bn@niasdigital.com>
cc: David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch/rfc 2/4] pcf875x I2C GPIO expander driver
In-Reply-To: <1207277135.4082.37.camel@moss.renham>
Message-ID: <Pine.LNX.4.64.0804032014190.20532@t2.domain.actdsltmp>
References: <200710291809.29936.david-b@pacbell.net>  <200711301040.54777.david-b@pacbell.net>
  <20071130211332.49a21a6b@hyperion.delvare>  <200711301259.22666.david-b@pacbell.net>
  <Pine.LNX.4.64.0804031844500.11928@t2.domain.actdsltmp>
 <1207277135.4082.37.camel@moss.renham>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Ben Nizette wrote:
> On Thu, 2008-04-03 at 19:06 -0700, Trent Piepho wrote:
>> On Fri, 30 Nov 2007, David Brownell wrote:
>>> On Friday 30 November 2007, Jean Delvare wrote:
>>>>
>>>> So the user-space interface would be part of the generic GPIO
>>>> infrastructure? I like the idea.
>>>
>>> I thought that would make sense too! :)  Someone would need to
>>> write the code though.  Having such a mechanism would provide
>>> another "carrot" to migrate folk towards the gpiolib core.
>>
>> Here's some code to do this.  It's not entirely perfect yet, but it is
>> usable.
>
> I quite like the fact that this easily tracks labels but I like the
> interface of simple_gpio posted a few days back:
> http://lkml.org/lkml/2008/3/26/87
>
> Either way, anything unified is good.

Always too slow posting my patches.  I wrote this two months ago when there
wasn't anything else.

A char device allows better permissions and could be more efficient, if one
really wants to do extensive control of gpio lines from userspace.  I can see
how it might be preferrable in some instances.

The nice thing about sysfs is that you don't need any extra software to
interact with it.  It's very convienent when you're just trying to debug the
gpio driver you're writing or verify that the gpio lines you just connected
are doing things.  It's also nice to be able to say something like:
# run these commands to un-write protect flash
echo out > /sys/class/gpio/MPC85XX:5/direction
echo 1 > /sys/class/gpio/MPC85XX:5/value

Instead of a complicated process that includes directions for creating the
correct device file, compiling a program that will set gpio lines, downloading
said program's source, and so on.
