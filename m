Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZFHQXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZFHQXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZFHQXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:23:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbZFHQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:23:36 -0400
Date: Mon, 8 Jun 2009 09:21:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Clayton <chris2553@googlemail.com>
cc: Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org,
       James Bottomley <james.bottomley@hansenpartnership.com>,
       scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
In-Reply-To: <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
References: <200906061959.55592.chris2553@googlemail.com>  <200906062215.30571.chris2553@googlemail.com>  <1244381140.30664.12.camel@ht.satnam>  <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>  <1244413881.18742.31.camel@ht.satnam> 
 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>  <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>  <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>  <1244460875.12644.2.camel@ht.satnam>
 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Jun 2009, Chris Clayton wrote:
> 
> OK. I reversed that change and built and installed the kernel. It has
> withstood 100 reboots without a panic. Additionally, I pulled the
> latest changes (that will be rc8-git5, I think) from kernel.org,
> reversed the change to that kernel and built and installed it. That
> too withstood 100 reboots without a panic.
> 
> Let me know if there's anything else I can do to help fix this.

That's already pretty convincing.

James, Arjan? The original oops message is here (a jpg screen capture, 
unable to open initial console):

	http://lkml.org/lkml/2009/6/6/142

and it's this bug entry:

	Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13474
	Subject         : Oops whilst booting
	Submitter       : Chris Clayton <chris2553@googlemail.com>
	Date            : 2009-06-06 18:59 (2 days old)
	References      : http://marc.info/?l=linux-kernel&m=124431487924254&w=4

and now bisected down to 

>> commit d5a877e8dd409d8c702986d06485c374b705d340
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Sun May 24 13:03:43 2009 -0700
>>
>>     async: make sure independent async domains can't accidentally entangle

please advice. Otherwise I'll have to revert.

		Linus
