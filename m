Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYJFURB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYJFURB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 16:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbYJFUQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 16:16:53 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:57945 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFUQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 16:16:52 -0400
Date: Mon, 6 Oct 2008 22:16:50 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to
	stop_machine infrastructrue.
Message-ID: <20081006201650.GA4708@osiris.boeblingen.de.ibm.com>
References: <20081003105632.357231142@de.ibm.com> <200810061542.41224.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810061542.41224.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 02:42:40PM +1000, Rusty Russell wrote:
> On Friday 03 October 2008 20:56:32 you wrote:
> > However we need to be able to do that without allocating any memory.
> 
> Nice work Heiko!
> 
> See free_module(), which calls stop_machine and, well, just hopes it works.  
> So we've needed this for a while.

Ah, good. At least there is one other user then :)

> > Patch 1 is a stop_machine bugfix and is independent of the rest
> Hmm, do you actually need this?  It was a whim (and clearly a dumb one).  I'm 
> tempted to change it to:
> 
> 	err = smdata->fn(smdata->data);
> 	if (err)
> 		smdata->fnret = err;

That looks much better than the cmpxchg loop I came up with. All we need to
know is that 'something' went wrong. Any return code != 0 should be enough.

> > Patch 2 introduces the new proposed interface
> 
> Could we just encapsulate the threads etc. into a "struct stopmachine" which 
> is returned from stop_machine_prepare(), then implement everything in terms 
> of that?

You mean that we put the pointers to the threads, the cpu mask, etc. in this
structure, instead of wasting bss size?
That would be just a kmalloc call in __stop_machine_get_threads().
Or do you think of something different?

Anyway, I'm going to send a hopefully better patch tommorrow.
