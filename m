Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZGBXtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZGBXtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZGBXtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:49:35 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:63200 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbZGBXtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=axl1GlUcmn1sTSd+EUgvjLPSXWGFQlia/0NMI5rehhzR+axDtRNrS0fpeNr3K/acm1
         7us/+LtS/EdzYYGaYYsvg0pC72SGoaBGoKw96bOWcF1NGHMChz44P2w8N3f62ZJV0m79
         meoV7YXTAhH4ExbErbJyP0x1UB9hGHYIaedhI=
Message-ID: <4A4D478F.8090304@gmail.com>
Date: Thu, 02 Jul 2009 20:49:35 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090626)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: tools/perf compile error: ignoring return value of 'read', declared
 with attribute warn_unused_result
References: <4A4BF4A2.8030607@gmail.com> <20090702074419.GB19187@elte.hu>
In-Reply-To: <20090702074419.GB19187@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>>     CC builtin-stat.o
>> cc1: warnings being treated as errors
>> builtin-stat.c: In function 'run_perf_stat':
>> builtin-stat.c:243: error: ignoring return value of 'read', declared with attribute warn_unused_result
>> builtin-stat.c:256: error: ignoring return value of 'read', declared with attribute warn_unused_result
>> make: *** [builtin-stat.o] Error 1
>>
>> Apparently my version of gcc and/or glibc do not agree with -Werror.  Would the fix be as simple as:
>>
>>     if *read(go_pipe[0], &buf, 1) < 0) {
>>             perror("Failed to read go_pipe.");
>>             exit(1);
>>     }
>>
>> ?
> 
> Yeah, that's Ubuntu doing some must-check-warnings via headers, 
> right?
> 
> Frederic fixed a bug there yesterday - mind checking the latest 
> perfcounters code at:
> 
>   http://people.redhat.com/mingo/tip.git/README
> 
> ?
> 

It's Gentoo, actually, but likely the same issue.  I checked tip/master and it does not show the problem.

Thanks for taking the time to look into it,

-- 
Kevin Winchester
