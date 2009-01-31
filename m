Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZAaAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZAaAso (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZAaAsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 19:48:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49399 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbZAaAsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 19:48:22 -0500
Message-ID: <49839FB6.1080509@zytor.com>
Date: Fri, 30 Jan 2009 16:47:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Martin Hicks <mort@sgi.com>, tglx@linutronix.de, mingo@redhat.com,
       heukelum@mailshack.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: push old stack address on irqstack for unwinder
References: <20090130165053.GE7872@alcatraz.americas.sgi.com> <49838F39.6060603@zytor.com> <49839CC8.7060502@zytor.com> <20090131003921.GA13709@elte.hu>
In-Reply-To: <20090131003921.GA13709@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> Would be nice to have an #ifdef-less primitive for this - something like:
> 
> 	pushq_frame %rbp
> 
> and a matching:
> 
> 	popq_frame %rbp
> 
> for those cases that need it (this one doesnt as we dont pop out of the 
> stack).
> 

It certainly would if this isn't a singleton, which I think it could 
possibly be?

Otherwise it really should be a part of an entry/exit macro; this is 
somewhat special in that it sets up a frame pointer as something other 
than a normal entry/exit sequence.

	-hpa
