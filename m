Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbXETD6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbXETD6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 23:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756367AbXETD6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 23:58:11 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:38473 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbXETD6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 23:58:10 -0400
Message-ID: <464FC6AA.2060805@cosmosbay.com>
Date: Sun, 20 May 2007 05:55:22 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Folkert van Heusden <folkert@vanheusden.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de> <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr> <20070520001418.GJ14578@vanheusden.com>
In-Reply-To: <20070520001418.GJ14578@vanheusden.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sun, 20 May 2007 05:55:28 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Folkert van Heusden a écrit :
>>>> I do not see such on i386, so why for x86_64?
>>> So that you know that one of your programs crashed. That's a feature.
>> This feature could be handy for i386 too.
> 
> Since 2.6.18.2 I use this patch. With 2.6.21.1 it still applies altough
> with a small offsets. Works like a charm.
> 
> 
> Signed-off by: Folkert van Heusden <folkert@vanheusden.com>
> 
> --- linux-2.6.18.2/kernel/signal.c      2006-11-04 02:33:58.000000000 +0100
> +++ linux-2.6.18.2.new/kernel/signal.c  2006-11-17 15:59:13.000000000 +0100
> @@ -706,6 +706,15 @@
>         struct sigqueue * q = NULL;
>         int ret = 0;
> 
> +       if (sig == SIGQUIT || sig == SIGILL  || sig == SIGTRAP ||
> +           sig == SIGABRT || sig == SIGBUS  || sig == SIGFPE  ||
> +           sig == SIGSEGV || sig == SIGXCPU || sig == SIGXFSZ ||
> +           sig == SIGSYS  || sig == SIGSTKFLT)
> +       {
> +               printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
> +                       sig, t -> pid, t -> uid, t -> gid, t -> comm);
> +       }
> +

Please check line 219 of Documentation/CodingStyle, Section 3.1: Spaces

	and no space around the '.' and "->" structure member operators.

Thank you

