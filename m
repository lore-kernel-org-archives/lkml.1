Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbYAVSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbYAVSYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYAVSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:24:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45748 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbYAVSY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:24:27 -0500
Message-ID: <479634A9.1090908@zytor.com>
Date: Tue, 22 Jan 2008 10:23:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>	 <1200758937-22386-2-git-send-email-ijc@hellion.org.uk>	 <47939363.8040603@kolumbus.fi>	 <1200950633.15491.21.camel@cthulhu.hellion.org.uk>	 <479510CE.7010706@zytor.com>	 <1200951996.15491.28.camel@cthulhu.hellion.org.uk>	 <479551FD.5040801@zytor.com> <1201023401.5643.52.camel@localhost.localdomain>
In-Reply-To: <1201023401.5643.52.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> On Mon, 2008-01-21 at 18:16 -0800, H. Peter Anvin wrote:
>> Ian Campbell wrote:
>>> I'm just preparing to send out a version which uses the native_* way of
>>> doing things, its not actually as clean as I would like so I'd be
>>> interested to see the ASM variant.
>>>
>> This is the asm version I came up with.
> 
> I moderately prefer the C version, even if it is in a restricted
> environment where care is needed to access global variables. I like that
> it avoids multiple copies of the code and also find the structure of
> what's going on is more obviously apparent (even to someone who has done
> plenty of ASM mode page table frobbing in the past).
> 
> Anyhow, I don't feel all that strongly about it so if the opinion of the
> early start of day maintainer(s) is strongly in favour of ASM I'll defer
> to that.
> 

My opinion is that I want it done properly (PIC and all that jazz) or 
not at all, and certainly would not want to mix linear and 
paging-enabled code in the same file.  When it comes to assembly code, 
at least people can *see* that there there be dragons.

The plus *and* minus of a C version is that it's easier for people to 
modify.  The plus side of that is that if we really need it, it's a lot 
cleaner; the minus side is that it may encourage more code to creep into 
the pre-paging code, which would not be a good thing IMO.

	-hpa
