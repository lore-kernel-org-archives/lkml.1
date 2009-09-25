Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZIYQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZIYQ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZIYQ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:27:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43471 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbZIYQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:27:14 -0400
Message-ID: <4ABCED94.4010804@zytor.com>
Date: Fri, 25 Sep 2009 09:19:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Rusty Lynch <rusty.lynch@intel.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Vamsi Krishna S <vamsi_krishna@in.ibm.com>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nathan Sidwell <nathan@codesourcery.com>,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Anton Massoud <anton.massoud@ericsson.com>,
       Richard J Moore <richardj_moore@uk.ibm.com>
Subject: Re: Immediate values
References: <20090924191642.GA19225@elte.hu>	<20090924193422.GB2533@elte.hu>	<20090925085119.2b77ea04@infradead.org>	<20090925073512.GA10346@Krystal>	<20090925110206.50ab8a20@lxorguk.ukuu.org.uk> <20090925121449.7bb27b61@infradead.org>
In-Reply-To: <20090925121449.7bb27b61@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 25 Sep 2009 11:02:06 +0100
> Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
>>> Then, following your advice, kprobes should be re-designed to do a
>>> stop_machine around the int3 breakpoint insertion ? And gdb
>>> should be stopping all threads of a target process before inserting
>>> a breakpoint. Therefore, I do not seem to be the only one confused
>>> about Intel statement on this issue.
>> There was considerable discussion abut this when the kprobe stuff went
>> in. If I remember rightly it was stated by someone @intel.com then
>> that int3 was ok (even though its not strictly documented as such).
>> The same is not true for all instructions on all x86 processors
>> unfortunately.
> 
> specifically, using int3 *and then going back to the old value*.
> 

As I told Mathieu in person yesterday:

1. We have no information if this is safe or not.  It is most certainly 
not documented as safe, and trying to play language lawyer with the 
errata text is pointless, as it's trying to interpret something that 
isn't there.

2. There are some reasons to believe there might be a safe technique 
somewhere in here (the one he described is a possibility, but not the 
only one.)

3. Being able to patch code without stopping all cores has other uses, 
and so spending some time doing legwork on it is probably worth it.

4. "Someone at Intel" isn't a reference... we need to track down actual 
CPU architects with real names who can give us a thumbs up or down.

	-hpa
