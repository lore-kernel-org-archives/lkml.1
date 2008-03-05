Return-Path: <linux-kernel-owner+w=401wt.eu-S1762923AbYCEWva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762923AbYCEWva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbYCEWvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:51:20 -0500
Received: from mail.suse.de ([195.135.220.2]:51667 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756865AbYCEWvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:51:20 -0500
Date: Wed, 5 Mar 2008 23:51:18 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: David Miller <davem@davemloft.net>
Cc: richard.guenther@gmail.com, hpa@zytor.com, Joe.Buck@synopsys.com,
       hubicka@ucw.cz, aurelien@aurel32.net, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
 flag
In-Reply-To: <20080305.141622.80343656.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de>
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
 <47CF11D6.7070901@zytor.com> <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com>
 <20080305.141622.80343656.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 5 Mar 2008, David Miller wrote:

> I will be sure to hunt you down to help debug when someone reports that 
> once every few weeks their multi-day simulation gives incorrect results 
> :-)

Give them a LD_PRELOADable DSO that intercepts signal() and sig_action(), 
installing a trampoline that first does "cld" and then jumps to the real 
handler.  That ought to be a quick test if it's this or a different issue.  
A hack, yes, but well... :)

> This is one of those cases where the bug is going to be a huge issue to 
> people who actually hit it, and since we know about the problem, 
> knowingly shipping something in that state is unforgivable.

Many bugs are a big issue to people who actually hit them, and we had (and 
probably still have) far nastier corner case miscompilations here and 
there and nevertheless released.  It never was the end of the world :)

Let it be a data point that nobody noticed the problem which existed in 
trunk since more than a year (since 2006-12-06 to be precise).


Ciao,
Michael.
