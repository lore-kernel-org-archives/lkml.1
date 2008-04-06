Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbYDFW61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbYDFW61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 18:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYDFW6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 18:58:18 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38025 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYDFW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 18:58:17 -0400
X-Greylist: delayed 1938 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Apr 2008 18:58:17 EDT
From: Ferenc Wagner <wferi@niif.hu>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu
Subject: Re: how to disable partition search?
References: <87ve39lngy.fsf@tac.ki.iif.hu>
	<20080406103743.GA31334@percy.comedia.it>
Date: Mon, 07 Apr 2008 00:25:56 +0200
In-Reply-To: <20080406103743.GA31334@percy.comedia.it> (Luca Berra's message
	of "Sun, 6 Apr 2008 12:37:43 +0200")
Message-ID: <877ifaoc23.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luca Berra <bluca@comedia.it> writes:

> On Wed, Mar 26, 2008 at 12:43:41PM +0100, Ferenc Wagner wrote:
>
>> I use an FC SAN, which provides multiple pathes to multiple LUNs.
>> These all come up as different sd* devices, exhausting single letter
>> names.  I mean they are a LOT.  Using the md mulitpath driver
>> everything works perfectly, no problems there.  However, during boot,
>> the kernel tries to read the partition table from each device,
>> spitting out hundreds of lines of error messages: most of the devices
>> aren't even readable, and those which are, don't contain a valid
>> partition table.  They never will.  So I'd like to disable partition
>> detection, because these messages overflow the kernel message buffer,
>> depriving syslog of gathering any useful boot messages, and also
>> needlessly lengthening the boot process.  (Of course the noise alone
>> is disturbing enough when one tries to troubleshoot a boot problem.)
>> However, looking at the kernel sources didn't give me any hint.  Is
>> this possible to disable at all?
>
> you could try bugging lkml until it dawns on them that partition
> detection code should belong in userspace by default :)

:) Very well put.  Thanks for strenghtening my belief.

> anyway you can rebuild your own kernel disabling it
> just set PARTITION_ADVANCED, and disable all partition types.

Sounds like a good idea, will try that!  This makes bugging lkml
unnecessary, if not for changing the default...  But that's more a
distribution issue, I think.  And now that we have udev and kpartx,
things will probably drift in this direction.

> you should be aware that doing this will disable partition detection on
> all drives, so if you have partitioned drives (eg boot drives) you have
> to run partx in initramfs or it wont be able to access them.

Not in this case.  I'm netbooting and getting / and co. from the SAN
via multipath and LVM, not a single partition on the whole cluster...
-- 
Thanks for the tip!
Feri.
