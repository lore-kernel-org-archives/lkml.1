Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030698Ab0B0TSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 14:18:54 -0500
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:28004 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030653Ab0B0TSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 14:18:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4GbqZaNEIkXVi/PyyaYFVurML12e6yZrHPbtTl6Fm6QUrsLoaHNQvHmfqhkCcEvuGUGKB6EcArfHnXwN6ohpuou826NbLOI576P5U1KjlgR56y+s/kYb4OvIbQAO9hxtSu7RsuNN3SPchdruMRBhbgaMhMCSe14cbhZleTqKJT8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: r5fepbwVM1mPWMdr255NKB730frireWlZYLrwSM4gB1Ar2Oo8k9Hru2rQoZjX4XUz3PcotzyuuhDHmRAoqjaJkInxLMqDf4ZMcEf5gN0HCTqfP7875cGlS8Zy9eAVRCKJeXyqPU9511U9ZNvq5p0f7iBMjEoIAuHumjZ2YqiRqtTRakgYox1v_cr1LmpqD34T.F0fIdHS4m5AZvt5XuTIb8N2eBjOm61Cr3.0JyiMmaP6hflTau10H9BU9TdxC7bXTLvSBz6U80793IJbEY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH v2] cs5535-gpio: change input/output enable to match gpiolib expectations
Date: Sat, 27 Feb 2010 11:18:51 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com> <1267296977-22626-1-git-send-email-gardner.ben@gmail.com>
In-Reply-To: <1267296977-22626-1-git-send-email-gardner.ben@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002271118.51842.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Ben Gardner wrote:

Patch seems OK, but the comment could stand correction:


> The intent of the gpiolib set_direction_xxx functions is as follows:

Clarification:  it's not "gpiolib" which expects that; "gpiolib"
is just an optional implementation infrastructure for the GPIO
programming interface.

That behavior is better described as a "weak expectation" than an
intent.  It comes from the GPIO programming interface, as described
in Documentation/gpio.txt ...

And the reason it describes that weak expectation is that it's how
most GPIO hardware behaves ... in particular, how the GPIO banks of
most System-on-Chip (SoC) processors behave.  (Even on boards with
external GPIO controllers, the SoC GPIOs generally outnumber the
external GPIOs by one or more orders of magnitude.)

Since the behavior of reading an "output" GPIO's value needs to
be specified ... this issue comes up.


> output: enable both input and output
> input: disable output, enable input

... the expectation is "weak" in that output-only is very
much allowed.  However, if a gpio is going to provide that
model, (a) it needs to report its value as 0/low/false when
asked, which (b) may well trigger some odd behavior in
some other driver code that expects more typical behavior

(You *could* also return 0/low/false for output-only GPIOs.
But this behavior is more typical, and much more useful.)

So a better explanation of this patch would emphasize that
it's providing "more typical behavior" to reduce surprises.


- Dave
