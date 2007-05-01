Return-Path: <linux-kernel-owner+w=401wt.eu-S1946015AbXEAVBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946015AbXEAVBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946022AbXEAVBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:01:53 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:58041 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946015AbXEAVBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:01:52 -0400
From: Jan Knutar <jk-lkml@sci.fi>
To: linux-kernel@vger.kernel.org
Subject: Re: Memory consumption on linux
Date: Wed, 2 May 2007 00:00:49 +0300
User-Agent: KMail/1.6.2
Cc: Christian Schmidt <lkml@digadd.de>
References: <4637958F.5010405@digadd.de>
In-Reply-To: <4637958F.5010405@digadd.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200705020000.49959.jk-lkml@sci.fi>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2007 22:31, Christian Schmidt wrote:

> And, how does process memory relate to system memory? Usually the sum
> of the resident memory (ps -o rss) is way off from the used memory
> displayed by free.

RSS has all the shared pages in it too.

> where you can see discrepancies in either direction, in one case 2G
> more free than resident, in the other case 60M less.

> Is there a way to get more detailed information on process and kernel
> memory usage? I assume that dm-crypto and software-raid use memory
> that does not show up anywhere.

Slab in /proc/meminfo, I guess. Lots of other values there too.The 
command slabtop -s c too.

> dynamips and vmware both mmap() the ram of the emulated machines
> (dynamips emulates cisco routers). Still, obviously the majority of
> the resident memory is "free", or rather "cached".

mmap() with a backing file is probably counted as "cached". mmap and 
brk() without backing files would probably be AnonPages 
in /proc/meminfo...
