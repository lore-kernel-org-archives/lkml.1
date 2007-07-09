Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbXGIOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbXGIOH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXGIOHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:07:21 -0400
Received: from gw.goop.org ([64.81.55.164]:37930 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbXGIOHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:07:19 -0400
Message-ID: <469240EA.8000301@goop.org>
Date: Mon, 09 Jul 2007 07:06:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andi Kleen <ak@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
References: <20070617214231.GA3588@stusta.de>	<46760D87.2000502@goop.org>	<20070708224444.GU3492@stusta.de>	<200707090102.21784.ak@suse.de> <20070709103223.5bfe24d4@the-village.bc.nu>
In-Reply-To: <20070709103223.5bfe24d4@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> There were a considerable number of sensible logical objections. You just
> didn't agree with them. You've now effectively made .22 unsupportable
> since we don't know if someone has binary virtualiser crap loaded.


The pv_ops infrastructure doesn't support modular pv_ops 
implementations, and if it did, there's certainly no intention of 
supporting non-GPL implementations.

At the same time that all the other altinstruction patching happens, it 
converts any indirect calls via paravirt_ops into direct calls to the 
target function, bypassing struct paravirt_ops altogether.  After that 
the structure is pretty much only used for patching modules.  Any 
attempt at writing a modular pv_ops implementation would fail as a result.

    J
