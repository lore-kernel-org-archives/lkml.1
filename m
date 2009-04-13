Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZDMSH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZDMSH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZDMSHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:07:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41470 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbZDMSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:07:14 -0400
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090413091423.GA19236@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain>
	 <1239340031.24083.21.camel@nimitz>
	 <20090413091423.GA19236@x200.localdomain>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 11:07:01 -0700
Message-Id: <1239646021.32604.45.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-13 at 13:14 +0400, Alexey Dobriyan wrote:
> On Thu, Apr 09, 2009 at 10:07:11PM -0700, Dave Hansen wrote:
> > I'm curious how you see these fitting in with the work that we've been
> > doing with Oren.  Do you mean to just start a discussion or are you
> > really proposing these as an alternative to what Oren has been posting?
> 
> Yes, this is posted as alternative.

I'm sure that you can understand that we've been working on Oren's
patches for a bit and don't want to jump ship on a whim. :)

Do you think we can change Oren's patch sufficiently to meet your needs
here?  Do you think we can change your patch sufficiently to meet Oren's
needs?

> Some design decisions are seen as incorrect from here like:
> * not rejecting checkpoint with possible "leaks" from container

Could you elaborate on this a bit?  This sounds really important, but
I'm having difficulty seeing how your patch addresses this or how Oren's
doesn't.

> * not having CAP_SYS_ADMIN on restart(2)
> * having small (TASK_COMM_LEN) and bigger (objref[1]) image format
>   misdesigns.

The format is certainly still in a huge amount of flux.  I'd be really
happy to see patches fixing these or clarifying them.  I'm planning on
going and looking at your patches in detail right now.  Would you mind
doing a more detailed review of Oren's so that we could use your
expertise to close some of these gaps in the format?

> * doing fork(2)+restart(2) per restarted task and whole orchestration
>   done from userspace/future init task.

Yeah, we've certainly argued plenty about this one amongst ourselves.
I'm personally open to changing this especially if you feel strongly
about it.

> * not seeing bigger picture (note, this is not equivalent to supporting
>   everything at once, nobody is asking for everything at once) wrt shared
>   objects and format and code changes because of that (note again, image
>   format will change, but it's easy to design high level structure which
>   won't change)
> * checking of unsupported features done at wrong place and wrong time
>   and runtime overhead because of that on CR=y kernels.

Yeah, I'm especially worried with respect to the shared objects right
now.  I'm pestering Oren to replace a big chunk of that stuff with other
garbage that I've dreamed up.  I'll go take a look at how you do this in
your patches...  Perhaps it will work even better.

-- Dave

