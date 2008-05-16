Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYEPFqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYEPFqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 01:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYEPFqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 01:46:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:21112 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbYEPFqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 01:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=s5cJn6Kl4kY/Z/uFv98SjsMjpYfHf8MffRc3AOld8j5oPwR73NllPvqpZWJKR/A9Jl2M/DRqAwsbOJeRU2zwdYXc/C4ikorAhygKVVKunMwwgJimxVIKO9IG+sZbSMYXh01WBiQ3fs53s1kz2M6tefhpfernhR9f/VyWIWIUWSM=
Date: Fri, 16 May 2008 05:49:59 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Kingsley Foreman <kingsley@internode.com.au>
Cc: Patrick McHardy <kaber@trash.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: NET_SCHED cbq dropping too many packets on a bonding interface
Message-ID: <20080516054959.GA3918@ff.dom.local>
References: <20080515091216.GA6550@ff.dom.local> <8ECDBB4EB5394859BFFACAAEE3A6EDB0@uglypunk> <482C6040.9030808@trash.net> <20080515182504.GB2936@ami.dom.local> <482C81CC.7000305@trash.net> <20080515184646.GC2936@ami.dom.local> <1A70765F4B30462EB21A3B3A8A442633@uglypunk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1A70765F4B30462EB21A3B3A8A442633@uglypunk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 06:57:23AM +0930, Kingsley Foreman wrote:
...
> running
>
> tc qdisc add dev bond0 root pfifo limit 1000
>
> or
>
> tc qdisc add dev bond0 root handle 1: cbq bandwidth 2000Mbit avpkt 1000 
> cell 0
> tc qdisc add dev bond0 parent 1: pfifo limit 1000
>
>
> doesn't appear to be dropping packets. 
>

Great! So it looks like there is no error here unless there are needed
significantly bigger queues to stop this dropping compared to 2.6.22.
You could try to lower this limit now to something like 10 to find when
drops start to appear. Why 2.6.22 doesn't need this at all is a mistery
anyway (old scheduler?), and it would really need some work (like git
bisection) to find the reason for more than 5 or 10 packet difference.

Thanks,
Jarek P.
