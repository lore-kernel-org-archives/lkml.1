Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZK1TB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZK1TB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 14:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZK1TB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 14:01:27 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:50948 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbZK1TB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 14:01:26 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>, yakui.zhao@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911141952.50030.rjw@sisk.pl>
	<87r5rwrkqs.fsf@tac.ki.iif.hu> <200911182313.14092.rjw@sisk.pl>
Date: Sat, 28 Nov 2009 20:01:08 +0100
In-Reply-To: <200911182313.14092.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Wed, 18 Nov 2009 23:13:14 +0100")
Message-ID: <87d4324gp7.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Wednesday 18 November 2009, Ferenc Wagner wrote:
>
>> Ferenc Wagner <wferi@niif.hu> writes:
>> 
>>> Since I've instrumented s2disk and the hibernation path, no freeze
>>> happened during hibernating the machine.
>> 
>> Not until I removed the delays from hibernation_platform_enter(), which
>> were put there previously to get step-by-step feedback.  Removing them
>> again resulted in a freeze in short course, maybe just two hibernations
>> later.  The instrumentation shows it stuck in dpm_suspend_start(PMSG_HIBERNATE).
>> Does it mean that some device driver is at fault?
>
> A driver or one of the platform hooks.
>
>> I'll check if it always fails at the same point (although tracing into
>> dpm_suspend_start isn't pure fun because of the multitude of devices it
>> loops over).  Is there any way to get printk output from that phase?
>
> Compile with CONFIG_PM_VERBOSE (it does mean exactly that).

The last message now was:

e100: 0000:02:08.0: hibernate, may wakeup

Looks like hibernating the e100 driver is unstable.
-- 
Regards,
Feri.
