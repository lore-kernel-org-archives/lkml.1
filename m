Return-Path: <linux-kernel-owner+w=401wt.eu-S1752258AbZIYLLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbZIYLLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZIYLLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:11:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbZIYLLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:11:43 -0400
Message-ID: <4ABCA5A4.5000605@redhat.com>
Date: Fri, 25 Sep 2009 04:12:36 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Richard J Moore <richardj_moore@uk.ibm.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@suse.de>,
       Anton Massoud <anton.massoud@ericsson.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Nathan Sidwell <nathan@codesourcery.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>
Subject: Re: Immediate values
References: <20090924191642.GA19225@elte.hu>	<20090924193422.GB2533@elte.hu>	<20090925085119.2b77ea04@infradead.org>	<20090925073512.GA10346@Krystal> <20090925110206.50ab8a20@lxorguk.ukuu.org.uk> <OF19654CE4.D069FD43-ON8025763C.0037FB4D-8025763C.00389751@uk.ibm.com>
In-Reply-To: <OF19654CE4.D069FD43-ON8025763C.0037FB4D-8025763C.00389751@uk.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard J Moore wrote:
> 
> 
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote on 25/09/2009 11:02:06:
> 
> 
>>
>> There was considerable discussion abut this when the kprobe stuff went
>> in. If I remember rightly it was stated by someone @intel.com then that
>> int3 was ok (even though its not strictly documented as such). The same
>> is not true for all instructions on all x86 processors unfortunately.
>>
>> Alan
> 
> Alan, I had that discussion with Intel, and yes int3 is a special case
> because of the interrupt processing associated with it. The discussion
> went along this lines: int3 is practically useless in an MP environment
> if it's trouble by the cross-modifying erratum.
> 
> I suppose it is possible the more recent microarchitectures have
> changed things. And yes, we might need to have that conversation again.

Hi,

I'm also very interested in this topic, since I'd like to replace
kprobe's int3 with jump instruction by using bypass code, which
Mathieu's new imv using.
http://lkml.org/lkml/2009/9/14/549

Actually, it is OK even if I need to use stop_machine(), because
the main goal is reducing overhead of probing, not reducing
the replacing time. :)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

