Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbYGZCxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbYGZCxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 22:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYGZCxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 22:53:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59922 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYGZCxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 22:53:23 -0400
Message-ID: <488A9174.40303@zytor.com>
Date: Fri, 25 Jul 2008 22:52:36 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Eli Collins <ecollins@vmware.com>, lkml <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: please revert commit 53f1b1433da7eac2607a4a0898a221a4485fd732
 (rtc: push the BKL down into the driver ioctl method)
References: <b6a2187b0807250726n77a0cd6eqb97b817fddc343b9@mail.gmail.com>	 <4889F78B.9090202@zytor.com> <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
In-Reply-To: <b6a2187b0807251918w2b2b3810h6c90df28a3261c7f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> On Fri, Jul 25, 2008 at 11:55 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Jeff Chua wrote:
>>> This commit is breaking vmware-6.0.4. Upon booting linux (guest) on
>>> vmware, the whole vmware environment crashed.
>> Quality hypervisor we have there...
> 
> Well then, lets hope Vmware will do something to fix this and remove
> the init_mm stuff.

Well, let me clarify:

- if userspace crashes the kernel, it is a kernel problem (except for 
abuse of certain specific privileged interfaces, like /dev/mem.)

- if a kernel crashes the hypervisor, it is likewise a hypervisor 
problem, even if it was triggered by a bug in the kernel.

The hypervisor, after all, is supposed to provide isolation.

As far as the kernel is concerned, the hypervisor is hardware.  Now, we 
work around bugs in broken hardware all the time, and *if it is sane*, 
we should do so here too.  However, it is *still* a hypervisor problem, 
and Vmware needs to fix it.

	-hpa

