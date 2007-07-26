Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXGZX3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXGZX3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbXGZX3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:29:46 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48515 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbXGZX3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:29:45 -0400
Message-ID: <46A92E30.8070703@ah.jp.nec.com>
Date: Fri, 27 Jul 2007 08:28:48 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       k-miyoshi@cb.jp.nec.com, Andrew Morton <akpm@linux-foundation.org>,
       Bernhard Walle <bwalle@suse.de>
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de> <20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de> <20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de> <20070726155444.GC15969@in.ibm.com>
In-Reply-To: <20070726155444.GC15969@in.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal wrote:
> On Thu, Jul 26, 2007 at 05:47:18PM +0200, Bernhard Walle wrote:
>> * Vivek Goyal <vgoyal@in.ibm.com> [2007-07-26 17:44]:
>>>> Of course, but that's why the patch doesn't change this by default but
>>>> gives the user the choice.
>>>>
>>> What value will distro set it to by default?
>> 0.
>>
>>> Can we be more specific in terms of functionality and code that exactly
>>> what we are trying to do after panic?
>> Well, KDB, but now everybody answers with “not mainline -- doesn't
>> count”.
>>
> 
> That's true. Its not mainline. We had similar discussion in the past
> also. I think we should allow only audited code to be run after panic().
> Leaving it open to modules or unaudited code makes this solution
> something like LKCD where whole lot of code used to run after the crash,
> hence was unreliable.

It is *not* KDB specific problem. Please grep in mainline kernel. You can find
some function using panic_notifier_list. (IPMI, softdog, heartbeat, etc...)
My patch gives a chance to use kdump for panic_notifier user. It is good for
kdump too, because kdump user goes to increase. :-)

Bernhard's idea (kdump uses panic_notifier) is very good for me. But it isn't
good for kdump user, because they want to take a dump ASAP when panicked.

Vivek, please think about this problem again.

If there is a developer who has the opinion on this problem, please give us your
opinion.

Thanks.

> If KDB goes mainline, then I think it is not a bad idea to call debugger
> first (if it is enabled) and then one can trigger crash dump from inside
> the debugger.
> Thanks
> Vivek
> 
> 
