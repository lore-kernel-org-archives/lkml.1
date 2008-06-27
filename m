Return-Path: <linux-kernel-owner+w=401wt.eu-S1762272AbYF0Q0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762272AbYF0Q0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 12:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761864AbYF0QZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 12:25:35 -0400
Received: from gw.goop.org ([64.81.55.164]:54352 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761933AbYF0QZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 12:25:33 -0400
Message-ID: <4865147B.50202@goop.org>
Date: Fri, 27 Jun 2008 09:25:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
 64-bit Xen support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627155656.GA19180@elte.hu> <48650F02.5080200@goop.org> <20080627160625.GA29488@elte.hu>
In-Reply-To: <20080627160625.GA29488@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> yeah, i guess so. Right now i only ran into the build failure so there's 
> hope :) Here's a config that fails to build for sure:
>
>   http://redhat.com/~mingo/misc/config-Fri_Jun_27_17_54_32_CEST_2008.bad
>   

Will look at it shortly.

> note, on 32-bit there's a yet unfixed initrd corruption bug i've 
> bisected back to:
>
> | 510be56adc4bb9fb229637a8e89268d987263614 is first bad commit
> | commit 510be56adc4bb9fb229637a8e89268d987263614
> | Author: Yinghai Lu <yhlu.kernel@gmail.com>
> | Date:   Tue Jun 24 04:10:47 2008 -0700
> |
> |    x86: introduce init_memory_mapping for 32bit
>
> so if you see something like that it's probably not a bug introduced by 
> your changes. (and maybe you'll see why the above commit is buggy, i 
> havent figured it out yet)

Well, on a non-PSE system find_early_table_space() will not allocate 
enough memory for ptes.  But I posted the fix for that, and it's likely 
you're using PSE anyway.  Nothing pops out from a quick re-read, but it 
could easily be mis-reserving the ramdisk memory or something.

    J
