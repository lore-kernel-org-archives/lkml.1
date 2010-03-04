Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0CDN1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:27:01 -0500
Received: from lo.gmane.org ([80.91.229.12]:37514 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab0CDN06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:26:58 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: evdev keyboard driver stopped working after upgrading from Kernel  2.6.33-rc8 to 2.6.33 (official release)
Date: Thu, 04 Mar 2010 13:25:57 +0000
Message-ID: <yw1xlje8z09m.fsf@unicorn.mansr.com>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com> <1267673633.6416.7.camel@marge.simson.net> <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: unicorn.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (garbanzo, linux)
Cancel-Lock: sha1:gibEDE39cbt9m8VZRM3s1oUnQXs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zeno Davatz <zdavatz@gmail.com> writes:

> On Thu, Mar 4, 2010 at 4:33 AM, Mike Galbraith <efault@gmx.de> wrote:
>> On Wed, 2010-03-03 at 21:45 +0100, Zeno Davatz wrote:
>
>>> I am always updating to the latest rc Kernel Release, that Linus shares via Git.
>>>
>>> I also upgraded to the latest stable kernel version after rc-8, to
>>> 2.6.33. But since I am on 2.6.33 my Xorg evdev-Driver stopped working.
>>> I can hit any key on the keyboard, but nothing will happen. The mouse
>>> and the graphics are just fine and work well.
>>>
>>> I have an Asus Eeepc 1101HA, with Gentoo and the psb-kmod driver compiled.
>>>
>>> Xorg starts just fine, does not crash but the keyboard does not react.
>>>
>>> Everything worked fine on 2.6.33-rc8.
>>>
>>> Any hints what changed from 2.6.33-rc8 to 2.6.33 stable that made my
>>> keyboard stop reacting?
>>>
>>> Let me know and I will test.
>>
>> I don't see any obvious candidates rc8->final.  There's _very_ little
>> for input.
>>
>> On the bright side, there are only 225 commits, so a bisection should be
>> almost painless.  That's probably your best bet for rapid resolution.
>
> Is there a possibility that something changed between rc2 and final,
> something that would concern the evdev driver or the keyboard input?
> It seems that /dev/input/event5 where the keyboard is found does not
> pass anything on to Xorg.

The inputX numbers are not stable.  I've had better luck using lines
like this in xorg.conf:

Section "InputDevice"
   [...]
   Option     "Device" "/dev/input/by-id/usb-_USB_Keyboard-event-kbd"
EndSection

This symlink will always point to whatever input device that keyboard
gets assigned to.

-- 
Måns Rullgård
mans@mansr.com

