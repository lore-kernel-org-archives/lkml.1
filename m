Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbYB2SSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbYB2SSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYB2SS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:18:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:53089 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYB2SS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=dItD0NCuSTJbKoIpprqpWbQKQei1HE5Fhp4y4XhNvPDwaxGA1gbeAgB2vpGevqUTVXnMSqHD00cWcZpdKO4e56mvxrpVG/fwSp2cRNBt8Js3HfzxvbEdau2/lqKYYhqgWINYt/GLoR/i+oI6ym+zPjEpElCPHS956r9l3BIya1s=
Message-ID: <47C84C6C.2000201@gmail.com>
Date: Fri, 29 Feb 2008 19:18:20 +0100
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <michael.kerrisk@googlemail.com>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, carlos@codesourcery.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com, Geoff Clare <gwc@opengroup.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
References: <1204119455.6242.403.camel@lappy>	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>	 <1204305244.6243.111.camel@lappy>	 <alpine.LFD.1.00.0802290934130.17889@woody.linux-foundation.org> <1204307756.6243.121.camel@lappy>
In-Reply-To: <1204307756.6243.121.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <michael.kerrisk@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Fri, 2008-02-29 at 09:35 -0800, Linus Torvalds wrote:
>> On Fri, 29 Feb 2008, Peter Zijlstra wrote:
>>> You fail to mention that <23 will still fault the first time it tries to
>>> grow the stack when you set rlimit_stack to 128k and actually supply
>>> 128k of env+arg.
>> So? That's what rlimit_stack has always meant (and not just on Linux 
>> either, afaik). That's not a bug, it's a feature. If the system has a 
>> limited stack, it has a limited stack. That's what RLIMIT_STACK means.
> 
> Well, I agree with that point. It just that apparently POSIX does not.
> According to Michael POSIX does not consider the arg+env array part of
> the stack proper.

AFAIK, POSIX.1 makes no requirement here.  Most (all?) Unix systems have 
traditionally placed argv+environ just above the stack, but that isn't 
required.

My reading of POSIX.1 (and POSIX doesn't seem very explicit on this 
point), is that the limits on argv+environ and on stack are decoupled, 
since POSIX specifies RLIMIT_STACK and sysconf(_SC_ARG_MAX) and doesn't 
specify any relationship between the two.
