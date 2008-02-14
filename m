Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbYBNQUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbYBNQUS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYBNQT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:19:58 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6240 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753520AbYBNQT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:19:57 -0500
Message-ID: <47B469E3.4080403@panasas.com>
Date: Thu, 14 Feb 2008 18:18:43 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: =?UTF-8?B?U3ZlbiBLw7ZobGVy?= <skoehler@upb.de>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Joerg Dorchain <joerg@dorchain.net>,
       Jon Chelton <jchelton@ffpglobal.com>,
       Stefan Priebe - allied internet ag 
	<s.priebe@allied-internet.ag>
Subject: Re: [PATCH] gdth: bugfix for the at-exit problems
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com>	 <47B1D7A8.8010108@panasas.com>  <47B1DA2A.1060904@panasas.com>	 <1202917468.3109.5.camel@localhost.localdomain>	 <47B312B3.3010200@panasas.com>  <47B31BDE.2030408@panasas.com>	 <1202921122.3109.31.camel@localhost.localdomain>	 <47B31FC2.4040206@panasas.com>	 <1202922226.3109.36.camel@localhost.localdomain>	 <47B324E7.9040502@panasas.com>	 <1202924198.3109.52.camel@localhost.localdomain>	 <47B41CBD.8040701@panasas.com>  <47B42CF4.2050008@panasas.com> <1203005443.3189.23.camel@localhost.localdomain>
In-Reply-To: <1203005443.3189.23.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Feb 2008 16:19:19.0360 (UTC) FILETIME=[59F28C00:01C86F25]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14 2008 at 18:10 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-02-14 at 13:58 +0200, Boaz Harrosh wrote:
>> This is a bugfix for the 2.6.24.x stable releases.
>>
>> gdth_exit would first remove all cards then stop the timer
>> and would not sync with the timer function. This caused a crash
>> in gdth_timer() when module was unloaded.
>> So del_timer_sync the timer before we delete the cards.
>>
>> also the reboot notifier function would crash. So unify
>> the exit and halt functions with a gdth_shutdown() that's
>> called by both.
> 
> The patch looks fine now, thanks.  Can we actually get a tester just to
> make sure there's nothing I missed.
> 
> James
> 
> 

Yes, and the tester reported, a breakage. We are on it.
Apparently, you cannot do a full deallocation of resources
at reboot notifier, nor would you want to I guess.

But you can do the flush. The exit call is never called
on a reboot and the card access is valid to the end.

Please comment?

So I pretty much reverted that patch, but did leave some
cleanups.

Also we found the other problems reported with user-mode tools
and cat /proc/sys/gdth/0

so 2 patches on the way above reverted. Give us a few ours to test
every thing.

Thanks
Boaz

