Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbXHDGGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbXHDGGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 02:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXHDGF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 02:05:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:9782 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXHDGF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 02:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GbF4JfuFZK2e/zRW1tnftmP87+Pl3mQLbnfD8/OR9TkRxBQPg3InGSQfF0D+pvh4ZpZYsSpkrdWQEAf0Y7ZFMUZTQLhtbEev3s9FR3QfVT9X91On9r5t1LuzzU2Kk4RDMuYb6/k5GuQlcZfGYeizMIcI9XLzYBzjHYbszW2Ao6Q=
Message-ID: <46B41706.4080008@gmail.com>
Date: Sat, 04 Aug 2007 15:04:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Mark Lord <lkml@rtr.ca>, jgarzik@pobox.com, linux-ide@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: ICH8 CF timeout (regression)...
References: <6278d2220708020348k26ac2293v648442f2281eca70@mail.gmail.com>	 <46B20D6B.1060506@gmail.com>	 <6278d2220708021411q17cdc151p79922e5dab74add4@mail.gmail.com>	 <46B25DE1.4050105@rtr.ca>	 <6278d2220708030322h2c779fa3o1e2e2d9c83ff62e8@mail.gmail.com>	 <46B30651.9030505@gmail.com> <6278d2220708031538s4a57f126ybfa0486816de4401@mail.gmail.com>
In-Reply-To: <6278d2220708031538s4a57f126ybfa0486816de4401@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman wrote:
> Tejun,
> 
> On 03/08/07, Tejun Heo <htejun@gmail.com> wrote:
>> Daniel J Blueman wrote:
>>> The ICH8 south-bridge I have is the mobile variant and does come
>>> equipped with native parallel IDE - see page 447:
>>> http://download.intel.com/design/chipsets/datashts/31305603.pdf . I do
>>> see 35MB/s with DMA enabled from my CF on the 1 in 15 times the
>>> libata-kernel does work.
>>>
>>> I can dump off and decode the configuration registers for the timing
>>> and bus master registers in the working and non-working libata cases,
>>> and the legacy ATA working case and see what's different.
>> Does the attached patch change anything?
> 
> This addresses the issue 100%!
> 
> Due to the differences between the ICH8 non-mobile and mobile
> variants, I've cooked the change into a new initialisation structure
> for the ICH8M in the attached patch, if that helps at all.
> 
> The changes thus affect (correct) behaviour on the ICH8M in IDE mode
> only...so should be safe for inclusion. There may be a similar
> situation with ICH9Ms also.

[cc'ing Kristen, hello]

I think [P0 P2 IDE IDE] is correct for MAP 01b but can't find anything
about it in the datasheet or spec update.  Kristen, can you please
verify this.  The following bug is also fixed by using [P0 P2 IDE IDE].

http://bugzilla.kernel.org/show_bug.cgi?id=8809

Thanks.

-- 
tejun
