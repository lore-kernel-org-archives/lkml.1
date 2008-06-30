Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbYF3SNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbYF3SNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 14:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763112AbYF3SMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 14:12:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33752 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbYF3SMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 14:12:52 -0400
Date: Mon, 30 Jun 2008 20:12:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Mark McLoughlin <markmc@redhat.com>,
       xen-devel <xen-devel@lists.xensource.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Stephen Tweedie <sct@redhat.com>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Xen-devel] Re: [PATCH 00 of 36] x86/paravirt: groundwork for
	64-bit Xen support
Message-ID: <20080630181221.GF23739@elte.hu>
References: <20080626105722.GA12640@elte.hu> <20080626105818.GA13805@elte.hu> <4863A8E6.1010807@goop.org> <20080627160333.GA27072@elte.hu> <486539A3.3030102@goop.org> <20080629084318.GA28815@elte.hu> <48684CD4.7040403@goop.org> <20080630082135.GA22844@elte.hu> <20080630092209.GA29815@elte.hu> <48691524.5010806@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48691524.5010806@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> config and full log can be found at:
>>
>>  http://redhat.com/~mingo/misc/config-Mon_Jun_30_11_11_51_CEST_2008.bad
>>   
>
> That config doesn't build for me.  When I put it in place and do "make 
> oldconfig" it still asks for lots of config options (which I just set 
> to default).  But when I build it fails with:

try 'make ARCH=i386 oldconfig' - does it work better that way?

> include2/asm/page_64.h:46:2: error: #error "CONFIG_PHYSICAL_START must be a multiple of 2MB"
> make[3]: *** [arch/x86/kernel/asm-offsets.s] Error 1
>
> I can fix that, of course, but it doesn't give me confidence I'm 
> testing what you are...

the problem there is that the 32-bit config has:

CONFIG_PHYSICAL_START=0x100000

which the 64-bit make oldconfig picked up, but that start address is not 
valid on 64-bit.

	Ingo
