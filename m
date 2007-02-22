Return-Path: <linux-kernel-owner+w=401wt.eu-S1751911AbXBVVc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbXBVVc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:32:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXBVVc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:32:58 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53141 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXBVVc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:32:57 -0500
In-Reply-To: <20070222.064704.71093028.davem@davemloft.net>
References: <20070222123929.GA5208@2ka.mipt.ru> <20070222.054127.104035694.davem@davemloft.net> <20070222143145.GA3246@elte.hu> <20070222.064704.71093028.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E58A1635-E5E7-4E0F-A231-29239CA2B148@oracle.com>
Cc: mingo@elte.hu, johnpol@2ka.mipt.ru, arjan@infradead.org,
       drepper@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, hch@infradead.org, akpm@zip.com.au,
       alan@lxorguk.ukuu.org.uk, suparna@in.ibm.com, davidel@xmailserver.org,
       jens.axboe@oracle.com, tglx@linutronix.de
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 22 Feb 2007 13:30:39 -0800
To: David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The more I think about it, a reasonable solution might actually be to
> use threadlets for disk I/O and pure event based processing for
> networking.  It is two different handling paths and non-unified,
> but that might be the price for good performance :-)

I generally agree, with some comments.

If we come to the decision that there are some message rates that are  
better suited to delivery into a user-read ring (10gige rx to kevent,  
say) then it doesn't seem like it would be much of a stretch to add a  
facility where syslet completion could be funneled into that channel  
as well.

I also wonder if there isn't some opportunity to cut down the number  
of syscalls / op in networking land.  Is it madness to think of a  
call like recvmsgv() which could provide a vector of msghdrs?  It  
might not make sense, but it might cut down on the per-op overhead  
for loads that know they're going to be heavy enough to get a decent  
amount of batching without fatally harming latency.  Maybe those  
loads are rare..

- z 
