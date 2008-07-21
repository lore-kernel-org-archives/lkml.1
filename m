Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbYGUBMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbYGUBMV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYGUBMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 21:12:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:63094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbYGUBME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 21:12:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m9FfM0Enm6SOSF4wEQSe94zgucdPaJKidy2cCH2go5ZFDJ0dFZJHlUikhnVLWt4bhc
         L3KxHL2HvRzOdE+S9M4A9k1T/Xyy3INiM43wulsN613QwoX7aWLaGNI/Cqf59muqPaIz
         g4Z/ir5UDXWXMwAY6PIhfyyRo5SeptROX9WL0=
Date: Mon, 21 Jul 2008 05:09:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080721010952.GA4822@martell.zuzino.mipt.ru>
References: <20080720.104411.81744468.davem@davemloft.net> <alpine.LFD.1.10.0807201751440.31863@woody.linux-foundation.org> <20080720.180304.51601407.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720.180304.51601407.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This is the main networking merge for 2.6.27

Looks like multiqueue changes broken netconsole (it remains silent).

Also, I had to enable CONFIG_NET_SCHED=y, otherwise it wouldn't link:

	net/built-in.o: In function `dev_queue_xmit':
	(.text+0x11210): undefined reference to `qdisc_calculate_pkt_len'
	net/built-in.o: In function `__qdisc_destroy':
	sch_generic.c:(.text+0x1ddcd): undefined reference to `qdisc_put_stab'

And finally, boot process hangs after TCP cubic is initialized.

This is net-2.6 tree (175f9c1bba9b825d22b142d183c9e175488b260c)
(tainted with conntracking-in-net-ns changes, though).

