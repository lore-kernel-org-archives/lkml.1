Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXH3Sro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXH3Sro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbXH3Srf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:47:35 -0400
Received: from mail.trixing.net ([87.230.125.58]:54590 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbXH3Srd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:47:33 -0400
Message-ID: <46D7108D.9090104@l4x.org>
Date: Thu, 30 Aug 2007 20:46:37 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Adrian Bunk <bunk@kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-alpha@vger.kernel.org
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org> <20070829234734.GA26410@stusta.de> <Pine.LNX.4.64.0708291736010.4526@schroedinger.engr.sgi.com> <46D66D49.20300@l4x.org> <Pine.LNX.4.64.0708301112030.7975@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0708301112030.7975@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: [1/4] 2.6.23-rc4: known regressions
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Thu, 30 Aug 2007, Jan Dittmer wrote:
> 
>> Christoph Lameter wrote:
>>> On Thu, 30 Aug 2007, Adrian Bunk wrote:
>>>
>>>> Christoph, is your fix in -mm suitable for 2.6.23, or how else should this
>>>> regression be fixed for 2.6.23?
>>> Looks like this is just alpha and a certain particular compiler version? 
>> binutils 2.15.95, gcc 3.3.6 and I could update to 4.0.4 or something
>> more recent I guess. And yes, it's only alpha.
>>
>> Of which file do you want the objdump?
> 
> The one where the link fails. Dump the code around the unresolved symbol.

Here is one of them:

   19380:       10 00 1f 20     lda     v0,16
   19384:       e6 ff ff c3     br      19320 <srmcons_get_private_struct+0x90>
                 * Generate a link failure. Would be great if we could
                 * do something to stop the compile here.
                 */
                extern void __kmalloc_size_too_large(void);
                __kmalloc_size_too_large();
   19388:       00 00 7d a7     ldq     t12,0(gp)
   1938c:       00 40 5b 6b     jsr     ra,(t12),19390 <srmcons_get_private_struct+0x100>
   19390:       00 00 ba 27     ldah    gp,0(ra)
   19394:       00 00 bd 23     lda     gp,0(gp)
   19398:       d6 ff ff c3     br      192f4 <srmcons_get_private_struct+0x64>
   1939c:       00 00 fe 2f     unop

Jan
