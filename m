Return-Path: <linux-kernel-owner+w=401wt.eu-S1760276AbYHZTiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276AbYHZTiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbYHZTiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:38:11 -0400
Received: from puma.cosy.sbg.ac.at ([141.201.2.23]:38058 "EHLO
	puma.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbYHZTiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:38:10 -0400
Message-ID: <48B45B8D.7010604@cosy.sbg.ac.at>
Date: Tue, 26 Aug 2008 21:37:49 +0200
From: Michael Noisternig <mnoist@cosy.sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: (e)poll and (rd)hup questions
References: <48B43C82.8060109@cosy.sbg.ac.at>
In-Reply-To: <48B43C82.8060109@cosy.sbg.ac.at>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> There's nothing synchronous in epoll WRT userspace. If you use epoll LT, 
> you don't need RDHUP. RDHUP was introduced to deal with special 
> connection states and epoll ET. Take a peek here for a detailed 
> description about how/why RDHUP was introduced:
> 
> http://lkml.org/lkml/2003/7/12/116
> 
> 
> - Davide

Thanks a lot for the explanation about RDHUP. Now that leaves me with 
only one question which I'm still not sure about: When I get HUP can 
there still be data in the kernel buffer to read out? (I guess so.)

Thanks again,
Michael

--Original message--
Michael Noisternig schrieb:
> Hello folks,
> 
> I hope this is a right place to ask this question. (Sorry if it isn't, 
> please hint me where to post in that case.)
> 
> This has been bugging me for quite some while now. I'm using epoll in 
> default level-triggered mode. I'm polling for input, output, rdhup, and 
> forcibly for hup. I figured that when I get EPOLLRDHUP that doesn't mean 
> there is no more data to read, presumably I must empty the kernel buffer 
> by continously reading from the fd until I get zero as a result 
> indicating rdhup. This means EPOLLRDHUP is delivered asynchronously and 
> thus is pretty useless to me.
> 
> On the other hand, EPOLLHUP seems to be delivered synchronously. If it 
> isn't then this means I get constantly notified about a closed fd until 
> I have read all data from the kernel buffer and remove the fd from the 
> epoll set (which makes being forced to hup notifications useless to me).
> 
> (And no, don't tell me to use edge-triggered mode, I have reasons to use 
> level-triggered.)
> 
> Question: Is my observation correct that EPOLLRDHUP is delivered 
> asynchronously in contrast to EPOLLHUP? Or is EPOLLHUP delivered 
> asynchronously as well?
> 
> Thanks, anwers would help a lot!!!
> Michael
> 
