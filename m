Return-Path: <linux-kernel-owner+w=401wt.eu-S1762361AbYDPRT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762361AbYDPRT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYDPRTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:19:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34113 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbYDPRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:19:19 -0400
X-IronPort-AV: E=McAfee;i="5100,188,5275"; a="2479803"
Message-ID: <48063513.7050505@qualcomm.com>
Date: Wed, 16 Apr 2008 10:19:15 -0700
From: Max Krasnyanskiy <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Vitaliy Ivanov <vitalivanov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb: remove macro code obfuscation
References: <35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com> <20080416105851.GB1621@elf.ucw.cz>
In-Reply-To: <20080416105851.GB1621@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Wed 2008-04-16 13:51:37, Vitaliy Ivanov wrote:
>> On Wed, Apr 16, 2008 at 1:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>  with macros. Fix that.
>>>
>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>>
>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>  with macros. Fix that.
>>>
>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>
>> Got it from the first time;)
>>
>> Do you think that now code looks better? As for me it's not...
> 
> Yes. Hiding & operator deep inside macro is evil for one thing. Plus
> it is no longer clear what the code does with the macros in there.

In general I would agree in this case it seems to actually make code clearer 
(I prefer original macros that is).
Anyway, I do not mind the change.

btw Marcel told me that all this queuing stuff does not actually make sense 
anymore. USB core did not support this before and HCI driver performance 
sucked without it. Marcel is telling me that things have changed.
So. Pavel, while you're at it can you maybe whack that stuff out completely ?
I mean all this custom _urb stuff that I did was eventually supposed to move 
into usb core. Then I stopped working on Bluetooth and it never happened. It'd 
be nice to clean that up since it seems that most of the latest bug reports 
are related to this urb business.

Thanx
Max



