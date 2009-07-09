Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbZGIPOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbZGIPOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759503AbZGIPOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:14:32 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:35023 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758641AbZGIPOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:14:31 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, johannes@sipsolutions.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Tomas Janousek" <tomi@nomi.cz>
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of b44/b43 modules
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	<bXZeuxPQAWE.A.Ap.lBpUKB@chimera>
	<87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
Date: Thu, 09 Jul 2009 17:14:20 +0200
In-Reply-To: <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de> (Jan Scholz's
	message of "Thu, 09 Jul 2009 00:02:26 +0200")
Message-ID: <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just checked this on v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547
(I wanted to test this on v2.6.31-rc2 as well, but there I had other
suspend-issues that are fixed in todays v2.6.31-rc2-214-g34f2547)

For both v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547 suspend to ram fails
with the test procedure described below, but it works fine when I revert
commit 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7
 "mac80211: cancel/restart all timers across suspend/resume"

Best regards,
   Jan

Jan Scholz <scholz@fias.uni-frankfurt.de> writes:

> Hi,
>
> I'm not sure if I experience the same bug on my apple iBook G4 (ppc
> 7447A, altivec supported PowerBook6,5) or just something very similar.
>
> With v2.6.30-rc1 I noticed, that suspending to ram does not work if my
> wireless card is 'up'. The wireless card is an apple airport extreme
> card, this is its lspci output:
>
> 0001:10:12.0 Network controller: Broadcom Corporation BCM4306 802.11b/g Wireless LAN Controller (rev 03)
>
> I tested suspend like this:
>
> # unload the wireless module
> modprobe -r b43
> echo mem > /sys/power/state
>
> # wake up works fine
>
> #loading b43
> modprobe b43
> echo mem > /sys/power/state
>
> # wake up still works fine
>
> ifconfig wlan0 up
> echo mem > /sys/power/state
>
> # the box does not wake up, I guess it's not really sleeping, because
> # the sleep led is not on
>
> I bisected this and got:
>
> 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7 is first bad commit
> commit 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Sun May 17 11:40:42 2009 +0200
>    
>     mac80211: cancel/restart all timers across suspend/resume
>
>
> Best regards,
>     Jan Scholz
>
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.29 and 2.6.30.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13337
>> Subject		: [post 2.6.29 regression] hang during suspend of b44/b43 modules
>> Submitter	: Tomas Janousek <tomi@nomi.cz>
>> Date		: 2009-05-18 10:59 (50 days old)
>>
