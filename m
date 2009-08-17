Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZHQJJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZHQJJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZHQJJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:09:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52649 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508AbZHQJJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:09:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A891E17.1090901@jp.fujitsu.com>
Date: Mon, 17 Aug 2009 18:08:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       ak@linux.intel.com, tglx@linutronix.de, Yinghai Lu <yinghai@kernel.org>,
       Huang Ying <ying.huang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-tip-commits@vger.kernel.org
Subject: Re: [boot crash] Re: [tip:x86/mce3] x86, mce: use 64bit machine	check
 code on 32bit
References: <tip-4efc0670baf4b14bc95502e54a83ccf639146125@git.kernel.org> <20090812113652.GA19632@elte.hu> <4A88E3E4.40506@jp.fujitsu.com> <20090817083544.GC15390@elte.hu>
In-Reply-To: <20090817083544.GC15390@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> wrote:
>> Could you try boot your laptop with mce=nobootlog?
> 
> Hm, why should that make any difference? mce=nobootlog only 
> influences whether we pass records into the mcelog buffer but does 
> not affect whether we touch the hardware.

Old mce codes doesn't take bootlog.

One possibility is: if the BIOS doesn't clear status in banks,
new mce codes will try to log such junks.
If the junk is totally junk but can be decoded as a valid log with
MISCV or ADDRV bit, and if the cpu try to access register which is
not implemented (e.g. IA32_MCi_MISC/ADDR), then such access might
cause a general protection exception. (ref. ASDM 3A 15.3.2.3)

I'm just guessing...


Thanks,
H.Seto

