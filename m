Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbXKFSlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbXKFSlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXKFSlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:41:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXKFSll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:41:41 -0500
Message-ID: <4730B548.8050100@zytor.com>
Date: Tue, 06 Nov 2007 10:41:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>	<m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>	<472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org>	<472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org>	<472FBF40.1010300@zytor.com> <472FC0F3.10102@goop.org>	<472FC401.9020202@zytor.com> <47309389.3080403@goop.org>	<47309608.9030200@zytor.com> <47309C85.6030904@goop.org>	<47309D98.8080003@zytor.com>	<m1zlxr5mik.fsf@ebiederm.dsl.xmission.com>	<4730AB1F.2030001@zytor.com> <m1fxzj5ix6.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1fxzj5ix6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> I have a hard time believing in discipline when I see the amount of
> not invented here and various oddball mistakes (cause by overlooking
> things) that seems to go on when extending the format.  We never
> needed to change the way the command line was passed, and we should
> have kept the longer jump where we had it.
> 

The longer jump was never documented, and so didn't exist.  There was 
definitely no way to rely on it.

The old command-line protocol had some really ugly interactions with the 
absolutely insane hoisting code from the pre-2.02 days.  I didn't have 
enough guts back then to scream and just rip it out, mostly because it 
took me a long time to figure out what the heck it really did (as 
opposed to what it claimed it did.)  That being said, we probably could 
have gotten away with leaving the protocol as-is while ripping out the 
guts (as I eventually did in the rewrite), even if the old protocol only 
had a 16-bit pointer.

> If we are going to through and add an additional pointer to a notes section
> let's please put a jump in there so we can make the header longer as
> we choose.

The problem is that that will only buy us 15 bytes, and eat up 3 (in 
practice, 4) of them...

It might be worth doing anyway, as it'd only break the 32-bit entrypoint 
users to reorganize struct boot_params.

	-hpa

