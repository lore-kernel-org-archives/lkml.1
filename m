Return-Path: <linux-kernel-owner+w=401wt.eu-S1751511AbZHZPbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbZHZPbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZHZPbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:31:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZHZPbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:31:47 -0400
Subject: Re: RFC: THE OFFLINE SCHEDULER
From: Peter Zijlstra <peterz@infradead.org>
To: raz ben yehuda <raziebe@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Chris Friesen <cfriesen@nortel.com>, Mike Galbraith <efault@gmx.de>,
       riel@redhat.com, mingo@elte.hu,
       andrew motron <akpm@linux-foundation.org>, wiseman@macs.biu.ac.il,
       lkml <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
In-Reply-To: <1251298443.4791.7.camel@raz>
References: <1250983671.5688.21.camel@raz>
	 <1251004897.7043.70.camel@marge.simson.net> <1251018551.3810.35.camel@raz>
	 <1251012621.14003.71.camel@marge.simson.net> <1251025557.3810.65.camel@raz>
	 <1251021133.14003.172.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251122020.26329@gentwo.org>
	 <1251222993.7023.53.camel@marge.simson.net>
	 <alpine.DEB.1.10.0908251402300.17963@gentwo.org>
	 <1251227322.7538.1172.camel@twins>  <4A943A00.9080609@nortel.com>
	 <1251264700.7538.1178.camel@twins> <1251282598.3514.20.camel@raz>
	 <alpine.DEB.1.10.0908260943090.9924@gentwo.org>
	 <1251297910.1791.22.camel@maxim-laptop>  <1251298443.4791.7.camel@raz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 17:30:25 +0200
Message-Id: <1251300625.18584.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 17:54 +0300, raz ben yehuda wrote:
> This is exactly what offsched (sos) is. you got it. SOS was partly
> inspired by the notion of a GPU. 

It is not, GPUs and other paired chips form a hybrid system. Linux is
known to run on one or more of such chips and communicate through
whatever means these chips have.

But what you propose here is hard partitioning a homogeneous system,
totally different.

> Processors are to become more and more redundant and Linux as an
> evolutionary system must use it. why not offload raid5 write engine ?
> why not encrypt in a different processor ?

Why waste a whole cpu for something that could be done by part of one?

> Also , having so many processors in a single OS means a bug prone
> system , with endless contention points when two or more OS processors
> interacts. 

You're bound to have interaction between the core os and these
partitions you want, non of it different from how threads in the kernel
would interact, other than that you're going to re-invent everything
already present in the kernel.

> let's make things simpler.

You don't, you make things more complex by introducing duplicate
functionality.

What's more, you burden the user with having to configure such a system,
and make choices on having to give up parts of his system, nothing like
that should be needed on a homogeneous system.

Work spend on trimming fat of of the core kernel helps everybody, even
users not otherwise interested in things like giving up a whole cpu for
some odd purpose.

There is no reason something could be done more efficiently on a
dedicated CPU than not when you assume a homogeneous system (which is
all Linux supports in the single image sense).

If you think the kernel is too fat and does superfluous things for your
needs, help trim it.


