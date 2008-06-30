Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbYF3R6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbYF3R6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 13:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbYF3R5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 13:57:45 -0400
Received: from gw.goop.org ([64.81.55.164]:37043 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762579AbYF3R5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 13:57:44 -0400
Message-ID: <48691E92.30809@goop.org>
Date: Mon, 30 Jun 2008 10:57:38 -0700
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
References: <20080625152212.GA3442@elte.hu> <4862A6A9.1030109@goop.org> <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu>
In-Reply-To: <20080630092209.GA29815@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>     
>>> Ingo Molnar wrote:
>>>       
>>>> with this config:
>>>>
>>>>   http://redhat.com/~mingo/misc/config-Sun_Jun_29_10_29_11_CEST_2008.bad
>>>>
>>>> i've saved the merged 2.6.26-rc8-tip-00241-gc6c8cb2-dirty tree into  
>>>> tip/tmp.x86.xen-64bit.Sun_Jun_29_10 and pushed it out, so you can test  
>>>> that exact version.
>>>>         
>>> Looks like the setup.c unification missed the early_ioremap init from 
>>> the early_ioremap unification.  Unconditionally call 
>>> early_ioremap_init().
>>>       
>> applied to tip/x86/unify-setup - thanks Jeremy.
>>
>> I've reactived the x86/xen-64bit branch and i'm testing it currently.
>>     
>
> -tip auto-testing found pagetable corruption (CPA self-test failure):
>
> [   32.956015] CPA self-test:
> [   32.958822]  4k 2048 large 508 gb 0 x 2556[ffff880000000000-ffff88003fe00000] miss 0
> [   32.964000] CPA ffff88001d54e000: bad pte 1d4000e3
> [   32.968000] CPA ffff88001d54e000: unexpected level 2
> [   32.972000] CPA ffff880022c5d000: bad pte 22c000e3
> [   32.976000] CPA ffff880022c5d000: unexpected level 2
> [   32.980000] CPA ffff8800200ce000: bad pte 200000e3
> [   32.984000] CPA ffff8800200ce000: unexpected level 2
> [   32.988000] CPA ffff8800210f0000: bad pte 210000e3
>
> config and full log can be found at:
>
>  http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_11_51_CEST_2008.bad
>   

This config doesn't have CONFIG_DEBUG_KERNEL enabled, let alone 
CONFIG_CPA_DEBUG.  I've noticed this seems to happen quite a lot: 
there's a disconnect between the log file and the config which is 
supposed to have built the kernel.  Is there a bug in your test 
infrastructure?

    J
