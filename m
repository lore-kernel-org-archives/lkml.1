Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZK2KMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZK2KMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 05:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbZK2KMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 05:12:20 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:34974 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbZK2KMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 05:12:19 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911182313.14092.rjw@sisk.pl>
	<87d4324gp7.fsf@tac.ki.iif.hu> <200911290129.25505.rjw@sisk.pl>
Date: Sun, 29 Nov 2009 11:12:13 +0100
In-Reply-To: <200911290129.25505.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Sun, 29 Nov 2009 01:29:25 +0100")
Message-ID: <873a3x4p36.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Saturday 28 November 2009, Ferenc Wagner wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>>> On Wednesday 18 November 2009, Ferenc Wagner wrote:
>>>
>>>> Ferenc Wagner <wferi@niif.hu> writes:
>>>> 
>>>>> Since I've instrumented s2disk and the hibernation path, no freeze
>>>>> happened during hibernating the machine.
>>>> 
>>>> Not until I removed the delays from hibernation_platform_enter(), which
>>>> were put there previously to get step-by-step feedback.  Removing them
>>>> again resulted in a freeze in short course, maybe just two hibernations
>>>> later.  The instrumentation shows it stuck in dpm_suspend_start(PMSG_HIBERNATE).
>>>> Does it mean that some device driver is at fault?
>>>
>>> A driver or one of the platform hooks.
>>>
>>>> I'll check if it always fails at the same point (although tracing into
>>>> dpm_suspend_start isn't pure fun because of the multitude of devices it
>>>> loops over).  Is there any way to get printk output from that phase?
>>>
>>> Compile with CONFIG_PM_VERBOSE (it does mean exactly that).
>> 
>> The last message now was:
>> 
>> e100: 0000:02:08.0: hibernate, may wakeup
>> 
>> Looks like hibernating the e100 driver is unstable.
>
> Can you verify that by trying to hibernate without the e100 driver?

Not really, as I still can't reliable reproduce the issue.  Since I'm
running with suspend loglevel = 8, it's happened only twice (in a row),
with seemingly exact same console output.  Some earlier freezes also
happened in dpm_suspend_start, at least.  However, I can certainly add
e100 to SUSPEND_MODULES under /etc/pm/config.d, and continue running
with that.  Or I can try stress-testing the module, but not sure, how.
Interestingly, git log v2.6.31.. -- e100.c is tiny, but 8fbd962e affects
the suspend/resume routines through e100_up.  This could explain the
timing-sensitive nature of the issue.  I took the liberty to change the
Cc list, maybe linux-netdev can lend us a hand.
-- 
Regards,
Feri.
