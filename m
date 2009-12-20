Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbZLTFLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbZLTFLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 00:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbZLTFLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 00:11:23 -0500
Received: from claw.goop.org ([74.207.240.146]:50034 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZLTFLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 00:11:22 -0500
Message-ID: <4B2DB1F8.2070006@goop.org>
Date: Sat, 19 Dec 2009 21:11:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Prevent from BITS_PER_LONG redefinition
References: <1261173920-11320-1-git-send-regression-fweisbec@gmail.com> <1261214767.20899.697.camel@laptop> <20091219143425.GA5003@nowhere>
In-Reply-To: <20091219143425.GA5003@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2009 06:34 AM, Frederic Weisbecker wrote:
> Yeah but we need it from the CPP level.
> We include such code located in kernel headers:
>
> static __always_inline unsigned long __fls(unsigned long word)
> {
> 	int num = BITS_PER_LONG - 1;
>
> #if BITS_PER_LONG == 64
> 	if (!(word&  (~0ul<<  32))) {
> 		num -= 32;
> 		word<<= 32;
> 	}
> #endif
> 	if (!(word&  (~0ul<<  (BITS_PER_LONG-16)))) {
> 		num -= 16;
> 		word<<= 16;
> 	}
>
>
> And sizeof() is not defined :)
>    

You can use if() with a constant expression instead of #if.

     J
