Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481Ab0ABFrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab0ABFrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 00:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081Ab0ABFrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 00:47:31 -0500
Received: from claw.goop.org ([74.207.240.146]:44310 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab0ABFra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 00:47:30 -0500
Message-ID: <4B3C8677.3030606@goop.org>
Date: Thu, 31 Dec 2009 22:09:43 +1100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com> <1261214767.20899.697.camel@laptop> <20091219143425.GA5003@nowhere> <4B2DB1F8.2070006@goop.org> <20091230214549.GF6322@nowhere>
In-Reply-To: <20091230214549.GF6322@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2009 08:45 AM, Frederic Weisbecker wrote:
>> You can use if() with a constant expression instead of #if.
>>      
>
>
> I did not write this code. But yes you're right, although I
> think CPP is more suitable here because fls() can be called
> from fastpath and this conditional build makes one check less
> and lesser i-cache footprint.
>    

Constant if()s are removed at compile time, so there should be no 
runtime overhead.  Constant if()s are generally preferable to #if 
because the compile will statically check the other code branch, even if 
it never gets executed, which helps prevent it from rotting.

     J

