Return-Path: <linux-kernel-owner+w=401wt.eu-S1757204AbZBEBEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204AbZBEBEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758072AbZBEBEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:04:05 -0500
Received: from ozlabs.org ([203.10.76.45]:44525 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757632AbZBEBEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:04:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/4] kthreads: rework kthread_stop()
Date: Thu, 5 Feb 2009 11:33:58 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Vitaliy Gusev <vgusev@openvz.org>,
       linux-kernel@vger.kernel.org
References: <20090130123358.GA26216@redhat.com> <200902042134.32346.rusty@rustcorp.com.au> <m1r62ew5ug.fsf@fess.ebiederm.org>
In-Reply-To: <m1r62ew5ug.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051133.59409.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009 02:29:35 Eric W. Biederman wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> > Clever? Sure.  Neat? Yes.
> >
> > But you are using a definition of obvious with which I was not previously
> > familiar :)
...
> Now Rusty I don't know about you but after I learned to do
> addition and subtraction it has always been obvious to me that
> one is the opposite of the other.

It is *not* obvious that the offset must be constant across all kthreads.  On
all architectures, and always will be.  That noone will *ever* put a
variable-size object on the stack in this code path.

I *think* it's true, but I've been surprised before.

> I am slightly concerned that using task_stack_page(tsk) may be
> overly clever, but compared to ACCESS_ONCE(), memory barriers,
> or not letting kthread_stop be called on a thread that may exit
> I think I am ahead of the game.

Absolutely agreed.  Just humor me please and put a BUG_ON in there :)

Thanks,
Rusty.
