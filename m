Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZAVW1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZAVW1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZAVW0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:26:55 -0500
Received: from gw.goop.org ([64.81.55.164]:59272 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZAVW0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:26:54 -0500
Message-ID: <4978F2A4.8010807@goop.org>
Date: Thu, 22 Jan 2009 14:26:44 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu>
In-Reply-To: <20090120112634.GA20858@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Ouch, that looks unacceptably expensive. All the major distros turn 
> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
> promise to have no measurable runtime overhead.
>
> ( And i suspect the real life mmap cost is probably even more expensive,
>   as on a Barcelona all of lmbench fits into the cache hence we dont see
>   any real $cache overhead. )
>
> Jeremy, any ideas where this slowdown comes from and how it could be 
> fixed?
>   

I just posted a couple of patches to pick some low-hanging fruit.  It 
turns out that we don't need to do any pvops calls to do pte flag 
manipulations.  I'd be interested to see how much of a difference it 
makes (it reduces the static code size by a few k).

    J
