Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbYF0OXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbYF0OXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYF0OXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:23:39 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:40031 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYF0OXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:23:38 -0400
Date: Fri, 27 Jun 2008 09:23:09 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Breno Leitao <leitao@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Anton Blanchard <anton@samba.org>
Subject: Re: [RFC/PATCH 0/3] sched: allow arch override of cpu power
Message-ID: <20080627142309.GR9594@localdomain>
References: <1213835374-10868-1-git-send-email-ntl@pobox.com>
 <4863F2CC.1030907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4863F2CC.1030907@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: A1DD0126-4454-11DD-9B98-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Breno Leitao wrote:
> Nathan Lynch wrote:
>> There is an "interesting" quality of POWER6 cores, which each have 2
>> hardware threads: assuming one thread on the core is idle, the primary
>> thread is a little "faster" than the secondary thread.  To illustrate:
>>   
> I found this feature interesting and decided to do some tests.
> After some tests I found that the example you post really runs fast in  
> the first CPU, but a more "elaborated" application runs slower on the  
> first CPU.
> Here is a small example:
>
> # taskset 0x1 time -f "%e,  %U, %S" ./a.out ; taskset 0x2 time -f "%e,  
> %U, %S" ./a.out
> 10.77,  10.72, 0.01
> 10.53, 10.48, 0.01
>
> # taskset 0x2 time -f "%e,  %U, %S" ./a.out ; taskset 0x1 time -f "%e,  
> %U, %S" ./a.out
> 10.55,  10.50, 0.01
> 10.77, 10.72, 0.01

I've been able to duplicate your results, thanks for the testcase.
Guess I'll need to understand what's going on before continuing with
this...
