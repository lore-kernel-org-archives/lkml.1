Return-Path: <linux-kernel-owner+w=401wt.eu-S1755328AbXKEAol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbXKEAol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbXKEAod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:44:33 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55492 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXKEAoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:44:32 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
	<alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
	<472E551E.2010507@zytor.com>
	<alpine.LFD.0.999.0711041546510.15101@woody.linux-foundation.org>
	<472E5DAB.8080804@zytor.com>
Date: Sun, 04 Nov 2007 17:43:30 -0700
In-Reply-To: <472E5DAB.8080804@zytor.com> (H. Peter Anvin's message of "Sun,
	04 Nov 2007 16:02:51 -0800")
Message-ID: <m1ve8ha5e5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Linus Torvalds wrote:
>>
>> And Linux always did it correctly. I don't understand why you disagree, and
>> why Jeremy says
>>
>> 	"Having successfully broken the rules for a long time so far, 	 maybe
>> we can get away with still cutting corners..."
>>
>> when the fact is, we used to *not* cut corners, we used to *not* break the
>> rules, and what we used to do (a short jump immediately after setting PE) was
>> exactly what Intel always said you should do, and there is no question
>> what-so-ever about it.
>>
>
> Apparently because the Intel documentation disagrees with itself. That's all.

Yes.  Let's go back to the tested version with the short jump, that
looks safest as it is what we have always done, and we certainly need some
kind of jump in there.

I do seem to recall etherboot having a far jump in that spot and it
working on everything from a 386 on up.  So I'm not certain if the
kind of jump matters.  Still the kernel has a lot more exposure.

At the same time it does look like we really do enter protected mode
with a valid gdt after the short jump so doing the segments loads as
I did originally in 32bit mode looks like it was excessively
conservative.

Eric
