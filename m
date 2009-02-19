Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbZBSQea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbZBSQea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZBSQeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:34:21 -0500
Received: from gw.goop.org ([64.81.55.164]:47455 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028AbZBSQeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:34:21 -0500
Message-ID: <499D8A0C.5030908@goop.org>
Date: Thu, 19 Feb 2009 08:34:20 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Petr Tesarik <ptesarik@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Definition of BUG on x86
References: <20090219121027.GB1703@elte.hu> <1235045971.15053.42.camel@nathan.suse.cz> <20090219122211.GE1703@elte.hu> <1235047082.15053.49.camel@nathan.suse.cz> <20090219124702.GC22044@elte.hu> <1235048535.15053.52.camel@nathan.suse.cz> <20090219144902.GA8650@elte.hu> <499D7B9D.7060001@goop.org> <20090219153544.GA31637@elte.hu> <1235059883.15053.68.camel@nathan.suse.cz> <20090219161649.GC9556@elte.hu>
In-Reply-To: <20090219161649.GC9556@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Well, the important question is thatGCC will optimize out 
> whatever comes after the __builtin_trap(), right? To guarantee 
> an assert we can do something like:
>
>  	__builtin_trap();
> 	panic("should never get here");
>
> to guarantee a message. (But realistically GCC will at most 
> generate a build error.)
>   

Ah, right, I remember the problem.  There's no guaranteed way of getting 
the address of the ud2a instruction __builtin_trap generates to put it 
into the bug table.

    J
