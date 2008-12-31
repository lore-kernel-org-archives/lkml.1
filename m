Return-Path: <linux-kernel-owner+w=401wt.eu-S1756180AbYLaNb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbYLaNb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbYLaNbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:31:49 -0500
Received: from mga10.intel.com ([192.55.52.92]:30856 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829AbYLaNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:31:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,308,1228118400"; 
   d="scan'208";a="653782118"
Message-ID: <495B7457.1040605@linux.intel.com>
Date: Wed, 31 Dec 2008 14:32:07 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mce merge, integration hickup + crash, design thoughts
References: <20081227155019.GA15493@elte.hu> <20081227225102.GA17822@elte.hu> <20081230211310.GA19653@sgi.com>
In-Reply-To: <20081230211310.GA19653@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russ Anderson wrote:

> Summary ASCII information is useful, especially if the error
> is clearly a hardware error.  Andi is right that decoding the
> information to print the specific failing hardware (ie which 
> DIMM) may be too dificult to decode on the way down.  It would
> be great to identify the failing hardware component on the
> way down, when possible.

This will hopefully happen in the future. In fact mcelog has support
to decode using DMI tables, but it turns out this doesn't work
very well in practice (both because of BIOS problems and because
the DMI standard was not really designed for this). That is why
I wouldn't advocate right now to move this code from mcelog
into the kernel. This might change later.


>>> It turns out that users don't really find this more enlightening (most 
>>> users have no clue what a Northbridge is).  They think it's some kind of 
>>> kernel bug even with the HARDWARE ERROR header.
>> You should not assume that administrators/users reading kernel crash 
>> messages are dumb. (an ordinary user wont see it most of the time anyway) 
>>
>> The usage patterns i see is that admins who get an MCE crash often fail to 
>> write down the whole MCE message (not realizing that it is important) and 
>> have to go back and reproduce the MCE crash once again before they can get 
>> any meaningful information.
> 
> This is why saving the error records to MVRAM is so useful.
> After reboot the records can be read, formatted, and logged.

I've been looking at using EFI runtime services for this, but it's
also somewhat problematic (e.g. getting the messages out again in
a useful way without risking duplicating events)

There are also a few other candidates like the Management Engine
interface on many Intel platforms, but it's also not available everywhere.

Short term just changing the MCE panic to timeout by default
is the best option. I'll probably submit that for .30

-Andi
