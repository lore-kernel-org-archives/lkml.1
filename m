Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbXJFKKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbXJFKKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 06:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXJFKKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 06:10:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54219 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXJFKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 06:10:22 -0400
Date: Sat, 6 Oct 2007 12:10:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [PATCH] vc bell config
In-Reply-To: <20071005170011.b4d280bf.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0710061203000.5969@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710051347000.13406@fbirervta.pbzchgretzou.qr>
 <20071005170011.b4d280bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 5 2007 17:00, Andrew Morton wrote:
>> 
>> It is already possible to deactivate the vc bell on a per-tty basis,
>> by using echo -en "\e[11;0]", but this is reset on reset(1).
>> 
>> This adds a sysfs parameter to globally control the vc bell, as well
>> as sysfs parameters for default pitch and duration.
>
>Why do we need this?  To fix the stupid-app-makes-my-box-beep problem, I
>guess.  Is there no other way of suppressing the beep?

The user has a number of choices:
- rmmod pcspkr, to disable all beeps (including X)
- vt.bell_enabled=0, to disable beeps on all VCs, but not X
- vt.default_bell_pitch=400, to give VC the frequency used in X
  (400 is perceived less penetrant than 750)

>>   * Here is the default bell parameters: 750HZ, 1/8th of a second
>>   */
>> -#define DEFAULT_BELL_PITCH	750
>> -#define DEFAULT_BELL_DURATION	(HZ/8)
>> +static unsigned int default_bell_pitch = 750;
>> +static unsigned int default_bell_duration = HZ / 8;
>
>It is inapt to call these default_X.  Because once they have been altered
>by the user, they aren't defaults any more.

They are still default, as in: they will define the initial
pitch/duration when a tty is created, or when the tty is reset.

If they were just 'bell_pitch', one culd assume that changing it
changes the pitch of all ttys, which it does not. Whether it's good
or not that the vc subsytem has per-tty pitches is a different story.

Well, that's what I am thinking about it.
