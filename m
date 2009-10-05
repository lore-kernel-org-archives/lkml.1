Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbZJEOD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbZJEOD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbZJEOD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:03:57 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:63629 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbZJEOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:03:56 -0400
Message-ID: <4AC9FCA6.8060203@anirban.org>
Date: Mon, 05 Oct 2009 07:03:18 -0700
From: Anirban Sinha <ani@anirban.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Darren Hart <dvhltc@us.ibm.com>,
       Kaz Kylheku <kaz@zeugmasystems.com>,
       Anirban Sinha <asinha@zeugmasystems.com>
Subject: Re: futex question
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>  <20091001092218.GH15345@elte.hu>  <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local>  <4AC68F13.8050601@us.ibm.com>  <alpine.LFD.2.00.0910041031330.2646@localhost.localdomain>  <DDFD17CC94A9BD49A82147DDF7D545C501F457C5@exchange.ZeugmaSystems.local>  <4AC8CF32.8060108@anirban.org>  <alpine.LFD.2.00.0910041853180.2646@localhost.localdomain>  <1254738974.26976.24.camel@twins>  <alpine.LFD.2.00.0910051251080.2646@localhost.localdomain> <1254741372.26976.35.camel@twins> <alpine.LFD.2.00.0910051346230.2646@localhost.localdomain> <4AC9F06B.8020708@anirban.org> <alpine.LFD.2.00.0910051525560.2646@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910051525560.2646@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Once upon a time, like on 09-10-05 6:28 AM, Thomas Gleixner wrote:
> Can you please fix your mail client to do proper line breaks at around
> 78 chars ?

Hmm. I made that change deliberately according to instructions in
Documentation/email-clients.txt so that it does not break my patches :) Anyway,
back to previous setting.

>>
>> We need to clear those pointers regardless. After the exceve(), the
>> address values are meaningless under the new mm context.
> 
> That's out of question. We just need to come to a decision whether we
> silently clean up callers dumbness or not.

Correct me if I am wrong, but according to Ingo:

> So i think exec() should release all existing state, unless told
> otherwise. Making it behave differently for robust futexes sounds
> assymetric to me.

I thought clearing the head pointers was a part of the stale existing state?
