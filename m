Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbZLARrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbZLARrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZLARrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:47:09 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:47420 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZLARrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:47:08 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [linux-pm] intermittent suspend problem again
References: <87fx93pwv2.fsf@tac.ki.iif.hu> <200911291607.05348.rjw@sisk.pl>
	<87y6ln0yxp.fsf@tac.ki.iif.hu> <200912011328.15551.rjw@sisk.pl>
Date: Tue, 01 Dec 2009 18:46:37 +0100
In-Reply-To: <200912011328.15551.rjw@sisk.pl> (Rafael J. Wysocki's message of
	"Tue, 1 Dec 2009 13:28:15 +0100")
Message-ID: <877ht68u4h.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 01 December 2009, Ferenc Wagner wrote:
>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>> 
>>> On Sunday 29 November 2009, Ferenc Wagner wrote:
>>>
>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>> 
>>>>> On Saturday 28 November 2009, Ferenc Wagner wrote:
>>>>>
>>>>>> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
>>>>>> 
>>>>>>> Compile with CONFIG_PM_VERBOSE (it does mean exactly that).
>>>>>> 
>>>>>> The last message now was:
>>>>>> 
>>>>>> e100: 0000:02:08.0: hibernate, may wakeup
>>>>>> 
>>>>>> Looks like hibernating the e100 driver is unstable.
>>>>>
>>>>> Can you verify that by trying to hibernate without the e100 driver?
>>>> 
>>>> Not really, as I still can't reliable reproduce the issue.  Since I'm
>>>> running with suspend loglevel = 8, it's happened only twice (in a row),
>>>> with seemingly exact same console output.  Some earlier freezes also
>>>> happened in dpm_suspend_start, at least.  However, I can certainly add
>>>> e100 to SUSPEND_MODULES under /etc/pm/config.d, and continue running
>>>> with that.
>>>
>>> That's what I'd do.
>> 
>> That worked out mosty OK (no freeze in quite some hibernation cycles),
>> but I'm continuing testing it.
>
> Great, please let me know how it works out.

Will do.  On the negative side, this tends to confuse NetworkManager.

>> On the other hand, I reverted 8fbd962e3, recompiled and replaced the
>> module, and got the freeze during hibernation.  And that was the bulk of
>> the changes since 2.6.31...  I'll revert the rest and test again, but
>> that seems purely cosmetic, so no high hopes.
>> 
>>> In addition to that, you can run multiple hibernation/resume cycles in
>>> a tight loop using the RTC wakealarm.
>> 
>> I'll do so, as soon as I find a way to automatically supply the dm-crypt
>> passphrase... or even better, learn to hibernate to ramdisk from the
>> initramfs. :)
>
> Well, you don't need to use swap encryption for _testing_. :-)

I use partition encryption, everything except for /boot is encrypted.
Apropos: does s2disk perform encryption with a temporary key even if I
don't supply and RSA key, to protect mlocked application data from being
present in the swap after restore?
-- 
Thanks,
Feri.
