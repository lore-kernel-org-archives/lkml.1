Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbZA1VB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbZA1VB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760011AbZA1VAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:00:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59575 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760801AbZA1VA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:00:28 -0500
Message-ID: <4980C73D.9010809@zytor.com>
Date: Wed, 28 Jan 2009 12:59:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Duncan Sands <baldrick@free.fr>, llvmdev@cs.uiuc.edu,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller
 	than input
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>	 <497F7BBE.4070500@zytor.com>	 <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>	 <497FBB30.3020804@zytor.com>	 <f73f7ab80901280528m6a4f123axbaff9ec284bebe32@mail.gmail.com>	 <498095F2.4060502@zytor.com> <f73f7ab80901281127t191c9c97nba99d859224e14bd@mail.gmail.com>
In-Reply-To: <f73f7ab80901281127t191c9c97nba99d859224e14bd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> On a BE 32-bit machine, the "output register" technically ought to be
> "64-bit" anyways, since it's constrained to be the same as the 64-bit
> "input register".  That means that you ought to make sure to set
> *both* output registers appropriately, one of them being 0 and the
> other being the 32-bit number.  I think that's the only answer that
> actually makes any sense from a holistic code-generation sense.  So it
> seems we are in violent agreement :-D.
> 

No.

This is wrong on two accounts.

First of all, THERE ARE NO "TWO OUTPUT REGISTERS".  Period.  There is 
only one.  The question is: which of the two *input* registers does it 
correspond to?

Second of all, "making sense from a holistic code-generation sense" 
doesn't apply here.  This is about mimicing a gcc construct, regardless 
of which amount of sense it makes.  Therefore, the only thing that 
actually makes sense is to mimic gcc behavior, no matter how stupid it 
happens to be.

	-hpa

