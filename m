Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZFLA4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZFLA4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZFLA4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:56:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52558 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZFLA4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:56:41 -0400
Message-ID: <4A31A7C3.8070802@jp.fujitsu.com>
Date: Fri, 12 Jun 2009 09:56:35 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH for tip/mce3] x86, mce: Add options for corrected errors
References: <4A30ACDF.5030408@jp.fujitsu.com> <20090611094706.GB12703@elte.hu>
In-Reply-To: <20090611094706.GB12703@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>> [ Repost, rebased on tip/x86/mce3]
>>
>> This patch introduces three boot options (no_cmci, dont_log_ce and 
>> ignore_ce) to control handling for corrected errors.
(snip)
> 
> Applied to tip:x86/mce3, thanks Hidetoshi!

It's a pleasure!

> A few sidenote:
> 
> Please introduce a sysctl for these too, for those were the flag can 
> be safely toggled after bootup (most of them look to be such flags). 
> Admins might want to tweak these options without rebooting the 
> system.
> 
> Even for those flags where a toggle means having to touch MSRs to 
> deactivate/(reactivate) CMCI we should do the sysctl thing, as 
> no-reboot configurability is king in this space.

Once I had a sysctl patch but that was for previous version of these
options, so now it will not suitable...
OK, I'll reinvent that one.  Please wait.

> a few random details:
> 
>>  static int			mce_bootlog = -1;
>>  static int			monarch_timeout = -1;
>>  static int			mce_panic_timeout;
>> +static int			mce_dont_log_ce;
>> +int				mce_cmci_disabled;
>> +int				mce_ignore_ce;
>>  int				mce_ser;
> 
> All rarely-modified variables should be declared __read_mostly.

True.  I'll make a incremental patch for these.

>>  static char			trigger[128];
> 
> Undocumented magic constant and meaninglessly named global variable, 
> please clean this up.

It looks like it is.  This variable was introduced by:
 commit a98f0dd34d94ea0b5f3816196bea5dba467827bb

I'll check the history and make a patch for this to rename, add comment
or so.


Thanks,
H.Seto

