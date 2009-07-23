Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbZGWBKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbZGWBKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:10:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZGWBKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:10:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33342 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbZGWBKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:10:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A67B840.2090401@jp.fujitsu.com>
Date: Thu, 23 Jul 2009 10:09:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <4A6564F2.10404@jp.fujitsu.com> <20090721110857.GA21612@hmsreliant.think-freely.org> <4A6672F9.3050800@jp.fujitsu.com> <20090722111049.GB4539@hmsreliant.think-freely.org>
In-Reply-To: <20090722111049.GB4539@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Wed, Jul 22, 2009 at 11:01:29AM +0900, Hidetoshi Seto wrote:
>> Neil Horman wrote:
>>  static void sysrq_handle_crash(int key, struct tty_struct *tty)
>>  {
>> -	char *killer = NULL;
>> -	*killer = 1;
>> +	panic("SysRq-triggered panic!\n");
>>  }
>>
> Well, this removes the ability from sysrq-c to test the oops handling path, but
> I suppose it does buy us consistent behavior between the keyboard and proc
> interfaces, which is likely more important.  I can agree to that.  Perhaps we
> can create another sysctl to test the oops path later.
> 
>> I agree that causing a real crash(panic) is better way to test crashdump than
>> calling the entry function of the crashdump directly, and also that opening
>> the path for other dump mechanisms is welcomed.
>>  
> Ok, so we're in line there :)
> 
>>> It seems to
>>> me that right now your major complaint is that the documentation is out of date,
>>> and you're having to do things slightly differently to get the same behavioral
>>> results.  Would it solve your issue, if we simply updated the documentation to
>>> illustrate how it works now?
>> Of course the documentation should be updated asap.
>> But I think the major complaint is about a difference in the behaviors of SysRq-c
>> and "echo c > /proc/sysrq-trigger".
>>
> Ok, I can agree with that.  I'd support a change like what you have above to
> bring the keyboard and proc interface behavior in line.

Thank you for your understanding!

I'll write & post a patch soon.  Please review it.


Thanks,
H.Seto

