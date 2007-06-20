Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbXFTWjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbXFTWjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXFTWjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:39:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19833 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbXFTWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:39:31 -0400
Message-ID: <4679AB7D.4070908@oracle.com>
Date: Wed, 20 Jun 2007 15:34:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, jengelh@linux01.gwdg.de,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: [PATCH 11/12] pcmcia/net_pcmcia: all net_pcmcia modules depend
 on PCMCIA
References: <20070619225203.GM5193@alberich.amd.com>	 <20070620134435.21410ceb.randy.dunlap@oracle.com> <a781481a0706201425j2c0e1fa9i147cc6ae17b74fd@mail.gmail.com>
In-Reply-To: <a781481a0706201425j2c0e1fa9i147cc6ae17b74fd@mail.gmail.com>
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi Randy,
> 
> On 6/21/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On Wed, 20 Jun 2007 00:52:03 +0200 Andreas Herrmann wrote:
>>
>> > Fix several build errors with PCMCIA=m && NET_PCMCIA=y:
>> >
>> >    LD      .tmp_vmlinux1
>> >    drivers/built-in.o: In function `nmclan_release':
>> >    nmclan_cs.c:(.text+0x14026c): undefined reference to 
>> `pcmcia_disable_device'
>> >    ...
>> >    drivers/built-in.o: In function `exit_xirc2ps_cs':
>> >    xirc2ps_cs.c:(.exit.text+0x1055): undefined reference to 
>> `pcmcia_unregister_driver'
>> >    make: *** [.tmp_vmlinux1] Error 1
>>
>> This is interesting.  This is a result of the menuconfig changes,
>> which made NET_PCMCIA a boolean, and then some tristates depend
>> on NET_PCMCIA and the boolean -> tristate dependencies aren't
>> specific enough.
>>
>> Your fix is one way to do it.  I'd prefer to make
>> NET_PCMCIA a tristate instead, then let its value trickle down
>> to the subordinate config symbols.
> 
> This is interesting indeed. But would it make much sense to
> mark a menuconfig item as tristate? I suspect the problem here
> was simply that these PCMCIA drivers did not explicitly depend
> on CONFIG_PCMCIA (which they should be, considering they
> pull in code from that particular subsystem), which Andreas'
> patch resolves ...
> 
> [ Also, when we make NET_PCMCIA tristate here, I suspect it
> would still be possible to select these drivers as built-in (even
> though PCMCIA can be modular) which would still give the
> above errors? I didn't test, so please correct me if I'm wrong. ]

I did test it.  If PCMCIA=m, with my patch, the NET_PCMCIA drivers
cannot be configured as built-in.

>> This probably means that some of the other menuconfig changes
>> need to be audited for this "feature."
> 
> Right. [ I didn't check git history, but it is also possible that
> these drivers not depend on PCMCIA like they should have
> before Jan did the menuconfig conversions too. ] But IMHO,
> the general lesson from this case is that if some driver depends
> on some other symbol, then we still need to honour that
> dependency explicitly instead of simply putting the driver inside
> a "#if <menuconfig_symbol>" and only making the
> <menuconfig_item> itself depend on the said dependency;
> otherwise the boolean / tristate problems you mentioned will bite,
> so an audit would clearly be in order.
> 
> Satyam


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
