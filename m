Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbZKXOtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbZKXOtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbZKXOtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:49:50 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:28149 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069AbZKXOtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:49:49 -0500
Subject: Re: [PATCH 0/1] Correct sorting problem in cfq_service_tree_add
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <4e5e476b0911240603q7df022bx5b5915aab6279537@mail.gmail.com>
References: <1259068293.3019.15.camel@cail>
	 <4e5e476b0911240603q7df022bx5b5915aab6279537@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 09:49:54 -0500
Message-ID: <1259074194.3019.106.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 15:03 +0100, Corrado Zoccolo wrote:
> On Tue, Nov 24, 2009 at 2:11 PM, Alan D. Brunelle <Alan.Brunelle@hp.com> wrote:
> > Found this whilst reviewing the CFQ I/O scheduler code: Currently, this
> > routine only sorts using the I/O priority class - it does not properly
> > sort prioritized queues within a specific class. The patch changes the
> > sort to utilize the full I/O priority (class & priority).
> 
> This changes mixes the interpretation of classes and levels within class.
> In the original code, those different things have different meanings:
> * priority class decides who can use the disk
> * priority level within a class determines how much of the disk time
> each queue will obtain
> In your case. instead, you completely remove the second meaning, and
> provide a larger number of levels to just decide the first.

Having read the ioprio.txt I had thought that the priorities within a
class should still be honored and that the time slice calculations in
cfq_prio_slice would be left as is. "ioprio" is probably the wrong field
name in the code (and text) then, as it is not meant as a priority but
as a time slice indicator?! The text in ioprio.txt and in the man page
for ionice are very inconsistent here: For example, the ionice man page
states: "This [best effort] class takes a priority argument from 0-7,
with lower number being higher priority. Programs running at the same
best effort priority are served in a round-robin fashion." Which implies
a secondary sort-order for priority within a class. Of course, both
ioprio.txt and the ionice man page also talk about class levels in a way
that may indicate it is not priority based. Hm...

Regards,
Alan

