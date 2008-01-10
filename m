Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbYAJUOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbYAJUOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYAJUOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:14:43 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37475 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYAJUOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:14:42 -0500
Message-ID: <47867C7E.3000100@panasas.com>
Date: Thu, 10 Jan 2008 22:13:50 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andre Noll <maan@systemlinux.org>
CC: Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [patch 1/1] Switch ioctl functions of drivers/scsi/sg.c to unlocked_ioctl
References: <20080110180529.GA32640@skl-net.de> <1199991298.3141.75.camel@localhost.localdomain> <20080110185944.GA1690@one.firstfloor.org> <20080110190748.GA20152@skl-net.de> <20080110192950.GG747@one.firstfloor.org> <20080110194550.GB20152@skl-net.de>
In-Reply-To: <20080110194550.GB20152@skl-net.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008 at 21:45 +0200, Andre Noll <maan@systemlinux.org> wrote:
> On 20:29, Andi Kleen wrote:
> 
>>> Sure, I can do that if James likes the idea. Since not all case
>>> statements need the BKL, we could add it only to those for which it
>>> isn't clear that it is unnecessary.
>>>
>>> And this would actually improve something.
>> I still think it would be a good strategy to first add it to all
>> (in a essentially nop semantics patch) and then later eliminate
>> it from the cases that obviously don't need it. 
> 
> James, would you accept such a patch?
> 
> Andre

Andre hi.

All the scsi calls do not need any locks. The scsi LLDS never
see these threads since commands are queued through the block
layer.

What's left is what you see, here in sg.c. you must have the best 
knowledge about the possible races between ioctl and open/release
and probe/remove. And all these put_user() copy_user() etc...
Why don't you have a hard look and fix them properly.

please don't *lock_kernel();* for scsi's sake. Also note that
sg is not a scsi device it is a block device. It used to Q commands
directly to scsi but it does not do that any more.

Again I think SCSI neto is safe and tested. My $0.02.

Boaz

