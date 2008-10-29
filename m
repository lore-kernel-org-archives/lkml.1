Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYJ2Dcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYJ2Dcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 23:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbYJ2Dcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 23:32:43 -0400
Received: from mga10.intel.com ([192.55.52.92]:61165 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbYJ2Dcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 23:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,504,1220252400"; 
   d="scan'208";a="632759939"
Message-ID: <4907D957.6040206@linux.intel.com>
Date: Tue, 28 Oct 2008 20:32:39 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, Yves-Alexis Perez <corsac@debian.org>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Long delays and keystrokes required - related to disk encryption?
References: <200810281744.52587.elendil@planet.nl> <200810290153.23514.elendil@planet.nl>
In-Reply-To: <200810290153.23514.elendil@planet.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Tuesday 28 October 2008, Frans Pop wrote:
>> I'm seeing some very strange behavior with 2.6.28-rc2-95-g49fdf67 on my
>> HP 2510p notebook.
>>
>> During the boot there are several places where I need to hit a key for
>> the boot to continue. There are also some very long delays before the
>> next syslog message is displayed.
>> The boot does continue and regularly hitting a key helps (but does not
>> get rid of all delays), but it is a huge regression from 2.6.27.
>>
>> The delays seem to continue until file systems get mounted.
>>
>> As the delays start at the point my system asks for the passphrase to
>> unlock (LUKS) encrypted disks, I suspect it has to do with that.
>> Especially since hitting a key seems to "trigger" new disk activity.
>>
>> However, the delays happen _again_ during shutdown, which makes it
>> extra strange that the system does behave normally when logged in.
>>
>> During the first boot wireless networking failed. During the second
>> boot, wireless networking did come up (without any relevant changes).
>> This gave an interesting extra data point: with wireless the delays on
>> shutdown started later: after iwlagn gets disabled.
> 
> I've bisected it to:
> commit dc4304f7deee29fcdf6a2b62f7146ea7f505fd42
> Author: Arjan van de Ven <arjan@linux.intel.com>
> Date:   Mon Oct 13 10:32:15 2008 -0400
>     rangetimers: fix the bug reported by Ingo for real
> 
> The bisection was one of those annoying ones where you switch branches
> often and get a load of config changes. This means that I'm not 100% sure
> about it, especially as the behavior changed for the last few "bad"s:
> instead of endlessly repeated delays there would be only a few of them
> immediately after entering the LUKS passphrase.

ok one easy thing to try, in the peek function (that this patch touches),
just stick a "return" as first statement in.
If that "fixes" it, we have a real issue with hrtimers, if not then something else is going on..

