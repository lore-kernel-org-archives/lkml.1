Return-Path: <linux-kernel-owner+w=401wt.eu-S1752531AbZGOGsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbZGOGsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 02:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZGOGsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 02:48:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:1801 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbZGOGsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 02:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <5d5443650907142321r1a4381eel96b955d85cd87114@mail.gmail.com>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
	 <d6200be20907131829o77bce3d8w8f238bc079478368@mail.gmail.com>
	 <20090714094629.GB2076@elf.ucw.cz>
	 <d6200be20907141507s39b54cccq9f0cedc325d3a203@mail.gmail.com>
	 <20090714221638.GA6512@elf.ucw.cz>
	 <d6200be20907141545k2b40b790x1af853b89517891c@mail.gmail.com>
	 <5d5443650907142321r1a4381eel96b955d85cd87114@mail.gmail.com>
Date: Tue, 14 Jul 2009 23:48:13 -0700
Message-ID: <d6200be20907142348k6962ef63o9a6ae444ca1f065c@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/14 Trilok Soni <soni.trilok@gmail.com>:
> Hi Arve,
>
> 2009/7/15 Arve Hjønnevåg <arve@android.com>:
>> On Tue, Jul 14, 2009 at 3:16 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> ...
>>>> >> This driver only supports a subset of Synaptics' devices so a more
>>>> >> generic driver will eventually be needed. The patch below adds support
>>>> >> for a more recent but similar panel.
>>>> >
>>>> > Ok, that should be simple enough to apply, but lets do improvements
>>>> > when we cleaned the code enough for the mainline...?
>>>>
>>>> We need this change now. Your cleanup will cause conflicts for anyone
>>>> using our driver, so it would be better if it includes all our fixes.
>>>
>>> Well, I don't expect you to use the cleaned-up driver as-is: I had to
>>> remove the wakelocks functionality as infrastructure is not in
>>> mainline.
>>
>> OK. The driver does not use wakelocks tough, only earlysuspend, so
>> your cleaned up version should be fully functional. The early suspend
>> hooks are only used to save power in idle when the screen is off.
>>
>>> (Plus, I do not have hardware to test your latest version).
>>
>> True, but the protocol documentation is available:
>> http://www.synaptics.com/sites/default/files/511_000099_01F.pdf
>>
>>>
>>> Applying small patch on top of cleaned up driver should be better than
>>> carrying whole driver itself, right?
>>
>> Perhaps, but the only problem I encountered with this driver so far
>> was when calling disable_irq from the interrupt handler stopped
>> working on non-smp systems in 2.6.30 (which is another patch you
>> should probably apply first).
>
> disable_irq review comment is already given in the patch posted on
> linux-input by Pavel. We should convert this driver to
> request_threaded_irq infrastructure instead. I have added linux-input
> ML in CC.
>

I looked into using request_threaded_irq a while ago, but decided it
was not worth it since I would still need to create the workqueue if
the interrupt was not available. However, if we drop support for
running without an irq then using request_threaded_irq should be
simpler.

-- 
Arve Hjønnevåg
