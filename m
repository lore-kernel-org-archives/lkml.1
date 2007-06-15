Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbXFOQOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbXFOQOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 12:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXFOQOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 12:14:36 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15080 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbXFOQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 12:14:34 -0400
X-IronPort-AV: i="4.16,425,1175497200"; 
   d="scan'208"; a="165900438:sNHT42721677"
To: "jidong xiao" <jidong.xiao@gmail.com>
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to printk unsigned long long variable?
X-Message-Flag: Warning: May contain useful information
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	<19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
	<20070615083355.f5bdb784.randy.dunlap@oracle.com>
	<4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 15 Jun 2007 09:14:25 -0700
In-Reply-To: <4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com> (jidong xiao's message of "Fri, 15 Jun 2007 23:39:59 +0800")
Message-ID: <adaabv1i49q.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 15 Jun 2007 16:14:25.0768 (UTC) FILETIME=[3E28F680:01C7AF68]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Is this right?

 >        dev->dev.dma_mask = bus->controller->dma_mask;
 >        printk(KERN_ERR "hey,jason,see,dma_mask is
 > %llu\n",*(dev->dev.dma_mask));

No, why do you have the '*' -- dma_mask isn't a pointer, is it?

You probably want:

	printk(KERN_ERR "hey,jason,see,dma_mask is %llx\n",
	       (unsigned long long) dev->dev.dma_mask);

(I would use a "%llx" format because masks are much clearer in hex).
The cast to unsigned long long is there because u64 is just unsigned
long on some 64-bit platforms, so you get a warning about the format
not matching on some architectures without the cast.

 - R.
