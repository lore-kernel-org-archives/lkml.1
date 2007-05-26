Return-Path: <linux-kernel-owner+w=401wt.eu-S1759198AbXEZNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759198AbXEZNPR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 09:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXEZNPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 09:15:06 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:49569 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbXEZNPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 09:15:05 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Arunachalam <arunachalamp@huawei.com>
Subject: Re: epoll,threading
Date: Sat, 26 May 2007 15:15:57 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <10815949.post@talk.nabble.com>
In-Reply-To: <10815949.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261515.58354.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arunachalam,

On Saturday 26 May 2007, Arunachalam wrote:
> I want to know in detail about , what the events (epoll or /dev/poll or
> select ) achieve in contrast to  thread per client.
> 
> i can have a thread per client and use send and recv system call directly
> right? Why do i go for these event mechanisms?

Try 30.000 clients or more on a x86 32bit box. 
That will show you the difference quite nicely :-)

More seriously: Thread per client scales only to a certain amount of clients
	per RAM. If you like to scale beyond that to like to minimize your state 
	per client. If you have a thread then you have a task structure as 
	unswappable memory in kernel, a per-thread stack, which is reducing 
	your virtual memory per process (you have only around 3GB of virtual 
	memory per process in Linux x86 32bit).

	So one uses a process or thread pool to scale beyond that. 
	Pool size is typically related to the amount of CPU cores in the system.

Regards

Ingo Oeser

