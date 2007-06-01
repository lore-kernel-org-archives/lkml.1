Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbXFAHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbXFAHZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXFAHZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:25:29 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50045 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXFAHZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:25:28 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: "Anand Jahagirdar" <anandjigar@gmail.com>
Subject: Re: Patch related with Fork Bombing Atack
Date: Fri, 1 Jun 2007 03:25:22 -0400
User-Agent: KMail/1.9.6
Cc: "Jens Axboe" <jens.axboe@oracle.com>, security@kernel.org,
       linux-kernel@vger.kernel.org
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com> <20070531134611.GZ32105@kernel.dk> <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
In-Reply-To: <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706010325.23185.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 02:48:59 Anand Jahagirdar wrote:
> On 5/31/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, May 31 2007, Anand Jahagirdar wrote:
> > > 2) Printk message in my patch will definitely help Administrator/Root
> > > User to detect which particular user is trying fork bombing attack on
> > > his machine by looking at /var/log/messages or dmesg . he can take
> > > action against that particular user and kill his processes.
> >
> > You just opened a DoS possibility for any user, they can now flood the
> > syslog instead.
>
> Jens Axboe
>
>      when they try to flood the syslog using fork bombing attack,
> their messge will be printed only once in syslog and it will show how
> many times it has repeated. due to this he will not able to flood the
> syslog.and i am using only one single variable in my printk messge so
> it is quite not possible to flood the syslog.
>
>    am i missing something??
>
> anand

Most definately. Each printk() call outputs to syslog - which means that every 
time your code outputs its message there is another line in the logs. It then 
becomes possible to use that to flood the syslog.

DRH

(I hate having to explain the obvious)
