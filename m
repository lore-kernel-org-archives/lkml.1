Return-Path: <linux-kernel-owner+w=401wt.eu-S964883AbXDAUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964883AbXDAUIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964888AbXDAUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:08:36 -0400
Received: from smtpout.mac.com ([17.250.248.171]:54852 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964883AbXDAUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:08:35 -0400
In-Reply-To: <Pine.LNX.4.61.0704012143120.16977@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> <Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr> <B118D361-9F40-456F-96B7-E61B16B98432@mac.com> <Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr> <2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com> <Pine.LNX.4.61.0704012058060.16977@yvahk01.tjqt.qr> <D260104B-C775-474E-B246-6298CD175205@mac.com> <Pine.LNX.4.61.0704012143120.16977@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <6B47532D-DD6A-4F1B-9A23-6AA67F6959BD@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH]
Date: Sun, 1 Apr 2007 16:07:52 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 01, 2007, at 15:47:18, Jan Engelhardt wrote:
> +config I_KNOW_WHAT_THE_HELL_I_AM_DOING
>
> Let's just hope kconfig does not bust the stack.
> Perhaps we could shorten that: I_KNOW_WTF_I_AM_DOING

Ah, good point, but I think it fits.

> +	bool "Prompt for config options which will break your computer"
>
> s/will break (.*)/could break $1 if done wrong/;

Well, we've had problems in the past where people turn on options  
under CONFIG_EXPERIMENTAL or CONFIG_EMBEDDED and it breaks in exactly  
the specified fashion and they complain on LKML.  The point of this  
is to expose kconfig tunables which a "normal" kconfig user would get  
wrong 99% of the time and would break in obscure ways.  For example,  
the "CONFIG_MULTITHREAD_PCI_PROBE" option, if it was re-added for  
more tinkering, could go under this option.

> +config EXPERT
> +	bool
> +	depends on I_KNOW_WHAT_THE_HELL_I_AM_DOING
> +	default y
>
> Given that, I hope the number of options dependent on CONFIG_EXPERT  
> will outnumber those depending on CONFIG_I_KNOW_WTF_I_AM_DOING.

Ah, see, due to the magic of kconfig language this does not show up  
as a separate option (no text for the "bool") identifier.  It's just  
an alias for I_KNOW_WHAT_THE_HELL_I_AM_DOING to make it easier to use  
in other Kconfig files ("depends EXPERT && SOME_OPTION!=n &&  
ANOTHER_OPTION") instead of s/EXPERT/I_KNOW_WHAT_THE_HELL_I_AM_DOING/g.

> If you want my answer: not-so-ACK, move the text to CONFIG_EXPERT  
> and let's stay sane for the next 366 days until next April 01.

:-D

Cheers,
Kyle Moffett

