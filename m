Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZICV0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZICV0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 17:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZICV0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 17:26:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbZICV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 17:26:00 -0400
Message-ID: <4AA0334F.5020004@zytor.com>
Date: Thu, 03 Sep 2009 14:21:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, jeremy.fitzhardinge@citrix.com,
       stable@kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <20090903211805.GB12566@elte.hu>
In-Reply-To: <20090903211805.GB12566@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2009 02:18 PM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 09/03/2009 01:45 PM, Jeremy Fitzhardinge wrote:
>>>
>>> Two problems:
>>>
>>>     * gcc generates %gs: references for stack-protector, but we use %fs
>>>       for percpu data (because restoring %fs is faster if it's a null
>>>       selector; TLS uses %gs).  I guess we could use %fs if
>>>       !CONFIG_CC_STACKPROTECTOR, or %gs if we are using it (though that
>>>       has some fiddly ramifications for things like ptrace).
>>
>> Well, by touching two segments we're getting the worst of both 
>> worlds, so at least assuming some significant number of real-world 
>> deployments use CC_STACKPROTECTOR, we really don't want to 
>> pessimize that case too much.
> 
> Fedora has stackprotector enabled so it's used in a widespread way.
> 
> 	Ingo

I'm guessing most distros do, except perhaps embedded ones.

	-hpa
