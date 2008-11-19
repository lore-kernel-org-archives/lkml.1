Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbYKSBHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbYKSBHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 20:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKSBH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 20:07:26 -0500
Received: from gw.goop.org ([64.81.55.164]:52250 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbYKSBH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 20:07:26 -0500
Message-ID: <492366CB.8020905@goop.org>
Date: Tue, 18 Nov 2008 17:07:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Eric Lacombe <goretux@gmail.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] do_arch_prctl - bug?
References: <200811181835.07360.goretux@gmail.com> <200811190044.11566.goretux@gmail.com>
In-Reply-To: <200811190044.11566.goretux@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Lacombe wrote:
> I look at the Intel docs (vol. 3A) again, and see that in 64 bits mode the 
> hidden field gs.base are physically mapped to the MSR, so it seems that in 
> order to load gs.base we don't need to load gs (like in 32 bits mode), but 
> rather we only need to load the MSR.
>
> So I don't understand the purpose of load_gs_index in that context :
>
> if (doit) {
> 	load_gs_index(0);
> 	ret = checking_wrmsrl(MSR_KERNEL_GS_BASE, addr);
> }
>
> Why don't we only load the MSR ?
> What is the purpose of calling load_gs_index with 0 as parameter ?
>   

Because %gs of 0 means "base too large, go to MSR".  If you have a 
32-bit base, then loading it into the gdt and loading %gs with the right 
selector is faster.  wrmsr/rdmsr are slow instructions.

    J
