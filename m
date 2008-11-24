Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYKXPGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYKXPGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYKXPFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:05:53 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:38659 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbYKXPFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:05:53 -0500
Message-ID: <ac3eb2510811240705q2133b4e5w6ac0ab6b41ccaa69@mail.gmail.com>
Date: Mon, 24 Nov 2008 16:05:51 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Patrick McHardy" <kaber@trash.net>
Subject: Re: Regression - Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
Cc: "Meelis Roos" <mroos@linux.ee>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <492AACB4.9070903@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee>
	 <49071A84.3080706@trash.net>
	 <Pine.SOC.4.64.0811212351200.16409@math.ut.ee>
	 <492AACB4.9070903@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 14:31, Patrick McHardy <kaber@trash.net> wrote:
> Meelis Roos wrote:
>>>>
>>>> request_module: runaway loop modprobe char-major-5-1
>>>>
>>>> and then hangs.
>>>>
>>>> char-major-5-1 seems to mean ttyS0.
>>>
>>> I'm seeing the same problem on a Debian unstable system using
>>> initramfs and dm-crypt, but it seems to be caused by userspace
>>> changes, using an old initramfs image with just the new modules
>>> added manually works fine (well, breaks elsewhere).
>>
>> I have done some eveninfs testing, taking apart and putting together my
>> own initramfs. It looks like this is a kernel bug, not userspace - the hang
>> happens after initramfs is unpacked and after VFS and quotas are installed,
>> and after "msgmni has been set to 627" message but before BSG loading
>> message and before io scheduler initialization. And log before init is
>> executed from initramfs (and no modprobe is executed either, as my wrapper
>> does not run).
>>
>> Rerepeating, same userspace generats fine initramfs for 2.6.27 and the
>> initramfs contents are the same except modules tree that is for different
>> version.
>>
>> It happens on 2 of my computers, both have custom config (serial compiled
>> in, not modular). The hang happens before ttyS driver initialization.
>
> char-major-5-1 is /dev/console here.
>
>> Seems like a kernel regression to me.
>
> It does, I changed some configuration options from =m to =y and
> it started working again. Unfortunately I'm unable to find the
> exact option that fixed it since I don't have the previous
> configuration anymore and random attempts to trigger the problem
> again failed.

Maybe you just miss /dev/console in initramfs? That would trigger the
kernel forked modprobe with that major/minor.

Some device nodes must be created or included in initramfs before any
action is taken.

Kay
