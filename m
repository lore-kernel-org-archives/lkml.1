Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbYHZRvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbYHZRvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYHZRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:51:11 -0400
Received: from puma.cosy.sbg.ac.at ([141.201.2.23]:59370 "EHLO
	puma.cosy.sbg.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbYHZRvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:51:10 -0400
X-Greylist: delayed 1525 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 13:51:10 EDT
Message-ID: <48B43C82.8060109@cosy.sbg.ac.at>
Date: Tue, 26 Aug 2008 19:25:22 +0200
From: Michael Noisternig <mnoist@cosy.sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: (e)poll and (rd)hup questions
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello folks,

I hope this is a right place to ask this question. (Sorry if it isn't, 
please hint me where to post in that case.)

This has been bugging me for quite some while now. I'm using epoll in 
default level-triggered mode. I'm polling for input, output, rdhup, and 
forcibly for hup. I figured that when I get EPOLLRDHUP that doesn't mean 
there is no more data to read, presumably I must empty the kernel buffer 
by continously reading from the fd until I get zero as a result 
indicating rdhup. This means EPOLLRDHUP is delivered asynchronously and 
thus is pretty useless to me.

On the other hand, EPOLLHUP seems to be delivered synchronously. If it 
isn't then this means I get constantly notified about a closed fd until 
I have read all data from the kernel buffer and remove the fd from the 
epoll set (which makes being forced to hup notifications useless to me).

(And no, don't tell me to use edge-triggered mode, I have reasons to use 
level-triggered.)

Question: Is my observation correct that EPOLLRDHUP is delivered 
asynchronously in contrast to EPOLLHUP? Or is EPOLLHUP delivered 
asynchronously as well?

Thanks, anwers would help a lot!!!
Michael
