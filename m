Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbYDSQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbYDSQST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 12:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYDSQSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 12:18:11 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34878 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYDSQSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 12:18:10 -0400
Date: Sat, 19 Apr 2008 18:18:42 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Vitaliy Ivanov <vitalivanov@gmail.com>, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: hci_usb: remove macro code obfuscation
Message-ID: <20080419161842.GC1577@elf.ucw.cz>
References: <35fbaa3e0804160351g1795b47bh6dbb2c8d596d0129@mail.gmail.com> <20080416105851.GB1621@elf.ucw.cz> <48063513.7050505@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48063513.7050505@qualcomm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-04-16 10:19:15, Max Krasnyanskiy wrote:
> Pavel Machek wrote:
>> On Wed 2008-04-16 13:51:37, Vitaliy Ivanov wrote:
>>> On Wed, Apr 16, 2008 at 1:42 PM, Pavel Machek <pavel@ucw.cz> wrote:
>>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>>  with macros. Fix that.
>>>>
>>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>>>
>>>>  I had trouble figuring out what the code does. atomic_inc/dec
>>>>  management is actually pretty simple, but it is needlessly obfuscated
>>>>  with macros. Fix that.
>>>>
>>>>  Signed-off-by: Pavel Machek <pavel@suse.cz>
>>>
>>> Got it from the first time;)
>>>
>>> Do you think that now code looks better? As for me it's not...
>>
>> Yes. Hiding & operator deep inside macro is evil for one thing. Plus
>> it is no longer clear what the code does with the macros in there.
>
> In general I would agree in this case it seems to actually make code 
> clearer (I prefer original macros that is).
> Anyway, I do not mind the change.
>
> btw Marcel told me that all this queuing stuff does not actually make sense 
> anymore. USB core did not support this before and HCI driver performance 
> sucked without it. Marcel is telling me that things have changed.
> So. Pavel, while you're at it can you maybe whack that stuff out completely ?
> I mean all this custom _urb stuff that I did was eventually supposed to 
> move into usb core. Then I stopped working on Bluetooth and it never 
> happened. It'd be nice to clean that up since it seems that most of the 
> latest bug reports are related to this urb business.

It seems someone already done that in (mainline) btusb.c

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
