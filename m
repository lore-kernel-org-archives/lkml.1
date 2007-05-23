Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbXEWTkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbXEWTkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759453AbXEWTkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:40:18 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:36393 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbXEWTkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:40:17 -0400
Message-ID: <465497E8.6060300@gmail.com>
Date: Wed, 23 May 2007 21:37:12 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
References: <1179829525.12708.118.camel@chaos> <46548ADB.60207@gmail.com> <20070523192816.GA16603@elte.hu>
In-Reply-To: <20070523192816.GA16603@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2007 09:28 PM, Ingo Molnar wrote:

> * Rene Herman <rene.herman@gmail.com> wrote:
> 
>> The trouble there is that unless you poll the bloody thing like mad 
>> too much of the Q subchannels passes below you and you need a huge 
>> number of retries to get anything out of it. I noticed when I started 
>> adding audio bits that the driver took full seconds to complete some 
>> audio requests while the old driver was snappy in that regard. When I 
>> replaced our sleeping loop with a busy-wait same as the original the 
>> snappyness returned and moreover, reading the TOC from the CD went 
>> from something close to a minute to approximately a second. Thought 
>> that minute was just because I was dealing with an old junk 1-speed 
>> drive...
> 
> ouch ...

Indeed...

> then i guess the right approach is to not use jiffies but to use a 
> calculated number of udelay(10) calls or so.

I'm not sure that will do -- the disc is still spinning below us while we're 
delaying/sleeping. Alan just now suggested checking need_resched which 
sounds like okay advice. I'll be trying what still works...

(given that noone uses these drives for anything serious anymore I'm in fact 
also not overly worried about being a busy-looping pig and just saying "this 
hardware sucks, why are you using it?").

Rene.

