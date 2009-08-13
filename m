Return-Path: <linux-kernel-owner+w=401wt.eu-S1752221AbZHMR6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbZHMR6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZHMR6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:58:46 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46851 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZHMR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:58:46 -0400
Date: Thu, 13 Aug 2009 19:58:43 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org
Subject: Re: [patch 2/2] Add a driver for the Winbond WPCD376I Consumer IR
 hardware
Message-ID: <20090813175843.GA11922@hardeman.nu>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
	jbarnes@virtuousgeek.org, akpm@linux-foundation.org
References: <20090809095645.198777507@hardeman.nu>
 <20090809095744.090206173@hardeman.nu>
 <20090813072905.56FB4526EC9@mailhub.coreip.homeip.net>
 <d92044dd553973571c2dd5cb18a925f9.squirrel@www.hardeman.nu>
 <20090813162726.DBD9A526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090813162726.DBD9A526EC9@mailhub.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 08:56:37AM -0700, Dmitry Torokhov wrote:
>On Thu, Aug 13, 2009 at 11:34:44AM +0200, David Härdeman wrote:
>> The main problem right now is that getkeycode is practically useless since
>> you can't blindly guess at a full range of 2^32 different scancodes to get
>> the complete keymap. Perhaps a index-based getkeycode would make sense...
>
>The drivers that have such sparce keymaps are expected to issue
>EV_MSC/MSC_SCAN events to aid userspace in identifying the "scancodes"
>that are emitted by the device.

Ok, I've added EV_MSC/MSC_SCAN support.

>>>> +static struct device_attribute dev_attr_last_scancode = {
>>>> +	.attr = {
>>>> +		.name = "last_scancode",
>>>> +		.mode = 0444,
>>>> +	},
>>>> +	.show = wbcir_show_last_scancode,
>>>> +	.store = NULL,
>>>> +
>>>> +};
>>>
>>> Why is this needed? And if this is needed we have a nice macro
>>> for that.
>>
>> I hope I've explained it wrt. EV_IR in my other mail. It's for building
>> keymaps of unknown remotes. And it'll go away once EV_IR is supported so I
>> don't think there's much point in fiddling with it now?
>>
>
>Because once the driver is in mainline it becomes part of userspace ABI
>and has to stay for a looong time.

I've removed the sysfs attribute as EV_MSC/MSC_SCAN provides the same 
functionality.

>> Thanks for the review. Are you willing to push the driver upstream through
>> the input tree once I've implemented your suggested fixes?
>>
>
>I'd need to take a look at your EV_IR patyches and see how they will
>affect this driver. I do nt want to merge something that will stay one
>way for half a release and then will switch to completely new interface.

The EV_IR functionality is intended to be used in addition to regular 
key up/down/repeat events. Much like EV_MSC/MSC_SCAN but more 
descriptive and specific to IR protocols. Then advanced user-space apps 
can choose whether to use the in-kernel keymap or map remote codes 
directly to suitable events (and it allows remote keymaps to be built 
easily in user-space).

As the future EV_IR functionality is additional to the current 
functionality, I hope the driver still can be merged before I have EV_IR 
patches ready for review. I'll post an updated patch shortly.

-- 
David Härdeman
