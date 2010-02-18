Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0BRXzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 18:55:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45709 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0BRXzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 18:55:22 -0500
Message-ID: <4B7DD336.6040700@zytor.com>
Date: Thu, 18 Feb 2010 15:54:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Luca Barbieri <luca@luca-barbieri.com>
CC: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] x86: add support for relative CALL and JMP in 
 alternatives
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>	 <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>	 <4B7D97A6.4060900@zytor.com> <ff13bc9a1002181538q7ccc1381x32a2f25bfb6d56cc@mail.gmail.com>
In-Reply-To: <ff13bc9a1002181538q7ccc1381x32a2f25bfb6d56cc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2010 03:38 PM, Luca Barbieri wrote:
>> The existing instruction parser is only present if KPROBES is configured
>> in... this patch would make it obligatory.  Your patch doesn't reflect
>> that.  Furthermore, it is ~16K of code and data which probably will make
>> embedded people unhappy... although perhaps isn't out of line.
> Didn't notice that.
> 
>> A good question, though, is if we actually need support for JMP or CALL
>> as anything but the first instruction (usually the *only* instruction),
>> which would make it a lot easier...
> 
> Probably not.
> I think an even better option is to create a CALL if replacementlen is 0xff.
> This would save some space for each callsite and make it clear we only
> support this usage.

That is an idea.

If we're going to do a full setup, it would be nice to handle general
relocations -- in addition to JMP and CALL, this would also allow
RIP-relative memory operands.  However, I think if we're going to do
that, it would be better to extract relocations at compile time (either
directly or via disassembly, which is basically what you're doing)
rather than at runtime.

	-hpa

