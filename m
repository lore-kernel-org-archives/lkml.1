Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbZHXWa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbZHXWa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbZHXWa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:30:56 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:37014 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbZHXWa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=YROHxzsR/fia0snp3cbFMy71OFdfwojEGLUHK84xVL7y+wmn3kWm6cWyUS2FMfG2cM
         hYniU2mUDM0jPOi+xPgg/nDRLmkDdtKdV5AfJeYFkI9Pwm0hZgfuwSi7closJffWA/+Y
         lzBnxxceKyZ0g8nhrLy2p2QfUWrLRyBJGHCgQ=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19091.1974.528045.724091@cargo.ozlabs.ibm.com>
References: <7c86c4470908200649u290f2378n126442ea3a823540@mail.gmail.com>
	 <19091.1974.528045.724091@cargo.ozlabs.ibm.com>
Date: Tue, 25 Aug 2009 00:30:56 +0200
Message-ID: <7c86c4470908241530r21804dbfqed2a218c3275ced5@mail.gmail.com>
Subject: Re: perf_counters issue with enable_on_exec
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:35 PM, Paul Mackerras<paulus@samba.org> wrote:
> stephane eranian writes:
>
>> I am running into an issue trying to use enable_on_exec
>> in per-thread mode with an event group.
>>
>> My understanding is that enable_on_exec allows activation
>> of an event on first exec. This is useful for tools monitoring
>> other tasks and which you invoke as: tool my_program. In
>> other words, the tool forks+execs my_program. This option
>> allows developers to setup the events after the fork (to get
>> the pid) but before the exec(). Only execution after the exec
>> is monitored. This alleviates the need to use the
>> ptrace(PTRACE_TRACEME) call.
>>
>> My understanding is that an event group is scheduled only
>> if all events in the group are active (disabled=0). Thus, one
>
> Not quite - if the leader is disabled then none of the group goes on.
> If the leader is enabled then it and any other group members that are
> enabled go on.  If a non-leader member is disabled then it doesn't go
> on but it doesn't stop other members from going on.
>
okay, what is not clear to me is why you need that level of granularity?
