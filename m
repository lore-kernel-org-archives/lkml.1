Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbXHCKXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbXHCKXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 06:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758917AbXHCKXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 06:23:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbXHCKXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 06:23:36 -0400
Date: Fri, 3 Aug 2007 06:23:25 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: gregfe <gregfe2002@yahoo.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Implementation of POSIX mqueues in Linux 2.6
Message-ID: <20070803102325.GY2063@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <76026.87188.qm@web26709.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76026.87188.qm@web26709.mail.ukl.yahoo.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 09:59:32AM +0000, gregfe wrote:
> I find little documentation on the actual implementation of POSIX message
> queues in Linux, and need some advise. In particular, I am wondering
> whether it supports inter-process *and* inter-thread communication, and if

Not sure what exactly you mean by inter-thread communication, whether
communication between threads within one process or between threads from
different processes.  You can use mq_* for either, except that mq_notify
registered signal notification is sent to the process that called mq_notify,
not thread (and for SIGEV_THREAD a new thread is created).

Though of course for communication between threads within one process
mq_* is a huge overkill.

> On more thing: kernel's "make menuconfig" of
> version 2.6.11 says :
> 
> >> To use this feature you will also need mqueue library, available
> 
> >> from <... a URL ... to M. Wronski's and K. Benedyczak's home page>"
> 
> Is it still up to date ?

No, glibc supports mq_* APIs for more than 3 years now.

	Jakub
