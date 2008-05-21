Return-Path: <linux-kernel-owner+w=401wt.eu-S1765107AbYEUJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765107AbYEUJzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbYEUJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:55:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbYEUJzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:55:43 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: Re: [PATCH 0/5] xen pvfb: Para-virtual framebuffer, keyboard and pointer driver updates
References: <87d4ngm4s4.fsf@pike.pond.sub.org> <4833E6BA.3060408@goop.org>
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 21 May 2008 11:54:29 +0200
In-Reply-To: <4833E6BA.3060408@goop.org> (Jeremy Fitzhardinge's message of "Wed\, 21 May 2008 10\:09\:14 +0100")
Message-ID: <87lk24j82y.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Markus Armbruster wrote:
>> This is an update to the Linux part of the Xen PVFB.  Linux Xen PVFB
>> is a pair of Xen para-virtual frontend device drivers:
>> drivers/video/xen-fbfront.c provides a framebuffer, and
>> drivers/input/xen-kbdfront provides keyboard and mouse.  Their
>> backends run in dom0 user space.
>>
>> Parts in this patch series:
>>
>> 1. Enable Xen console by default in domU
>> 2. Pointer z-axis (mouse wheel) support
>> 3. Module aliases to support module autoloading
>> 4. Zero unused bytes in events sent to backend
>> 5. Dynamic mode support (screen resizing)
>>
>> To the best of my knowledge, these patches are independent.  The last
>> one needs a bit of trivial merging to apply without the first one.  I
>> tested only 1, 1+2, 1+2+3, 1+2+3+4, and the complete series.  I'm
>> happy to split this into different parts if that helps.
>>   
>
> Thanks Markus,
>
> This looks good.  I'll stick it into my queue and feed it via Ingo
> when I've given it a bit of a test.

Thanks!

> Are we happy that the preferred console stuff is now the best
> solution?  Does it solve your installer issues?
>
>    J

Yes, the console stuff works nicely for me, and the installer is
happy.

Note that I went with the stupidest solution that could possibly work
there: have a global flag that gets set when the command line sets
consoles, and don't mess with the console then.  Mark McLoughlin
suggested a somewhat less stupid way, namely to mark consoles selected
on the command line with a flag.  Critical review invited!
