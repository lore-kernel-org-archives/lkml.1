Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZI3Feq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZI3Feq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 01:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZI3Fep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 01:34:45 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:56741 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZI3Fep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 01:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w9wryQlqjmNFo01W42W3q8TYKsku+SXz1jwZTukS6lPnSJWy16k6dmwIW8WbWP4idb
         +VFQ3eBKJJvycRO4BHzCfeZeJjRtvHmrPus4+YPcUtO2Ba7bH9nMkwfVAY7AIB8nKxL1
         k7T+5xmyDXIOkA2Lduqvjpqlbyg5QCN1wY3oE=
Date: Wed, 30 Sep 2009 09:34:43 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20090930053443.GA1010@x200>
References: <20090924165548.GA16586@us.ibm.com>
 <20090924175542.GA27678@x200>
 <20090924183556.GA31356@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924183556.GA31356@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 01:35:56PM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> > I don't like this even more.
> > 
> > Pid namespaces are hierarchical _and_ anonymous, so simply
> > set of numbers doesn't describe the final object.
> > 
> > struct pid isn't special, it's just another invariant if you like
> > as far as C/R is concerned, but system call is made special wrt pids.
> > 
> > What will be in an image? I hope "struct kstate_image_pid" with several
> 
> Sure pid namespaces are anonymous, but we will give each an 'objref'
> valid only for a checkpoint image, and store the relationship between
> pid namespaces based on those objrefs.  Basically the same way that user
> structs and hierarchical user namespaces are handled right now.

OK, that's certainly doable.

You're commiting yourself to creation of tasks in userspace if this goes in. :-\
Which can let you into putting wrong kind of relations into image.
IIRC, clone_flags were in image (still?), but tomorrow kernel will get
new way to acquire, say, uts_ns, which, in theory, can't be described by
a set of consecutive clones, so, you'll have to fixup something in kernel.

> > numbers and with references to such object from other places, so it
> > seems natural to do alloc_pid() with needed numbers and that attach new
> > shiny pid to where needed. But this clone_pid is only for task_struct's pids.
