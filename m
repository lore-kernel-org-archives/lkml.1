Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbYHBPm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbYHBPm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYHBPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:42:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbYHBPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:42:21 -0400
Message-ID: <4894800F.40802@zytor.com>
Date: Sat, 02 Aug 2008 08:41:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] dyn_array and nr_irqs support v2
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>	<m1iqukwjjg.fsf@frodo.ebiederm.org>	<86802c440808011430i6cf5cb8cn519777a78dd987b0@mail.gmail.com>	<m1wsj0nyx6.fsf@frodo.ebiederm.org>	<86802c440808011809t275aa511h4a1e9d70ede21702@mail.gmail.com>	<m163qkjirc.fsf@frodo.ebiederm.org>	<86802c440808011901w2aa40b25u45f5686b262cc2aa@mail.gmail.com>	<4893C066.60401@zytor.com> <m1abfwi1ht.fsf@frodo.ebiederm.org>	<4893D459.4030209@zytor.com> <m14p64gh81.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p64gh81.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Yes.  I want the option of using those bits.  It might not be smart to
> use them to encode a physical location and the irq number but just
> having the option would be nice.
> 

Urk!  First of all, there isn't enough space as we have already proven 
(on the machines where it actually matters there just aren't enough 
bits), but doing this kind of stuff *optionally* is going to hurt even 
worse.

Furthermore, this crap will break anyway the *next* time someone comes 
up with a new clever way to do interrupts -- and to truly get stable 
identifiers, we can't treat HyperTransport MSI as APICs anymore, yadda, 
yadda...

> Making /proc/interrupts useful without breaking user space is going to be
> an interesting challenge one of these days.

If changing to non-numbers in /proc/interrupts will break userspace, 
then userspace will have to deal with a numeric token in 
/proc/interrupts which will have to be looked up elsewhere (perhaps in a 
sysfs directory) to get a more meaningful index.

	-hpa
