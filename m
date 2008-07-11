Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbYGKAgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbYGKAgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYGKAg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:36:28 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:22356 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbYGKAg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LGIthlQwOjqKWVslOlRQ47q7ryqsj53fTVcRiTA6MrAmVfGWwFLtmYPq4eDe14fnQq
         lilv0U9r06r0Fcffku/P+shz1H+HA710Ltb/2mX0QYveDwlj4SZ31zloeNyrYLhIH3Hc
         Ow97r4acqTaY4xQqYCO9nNh3RWxbUJ+xINtiY=
Date: Fri, 11 Jul 2008 04:32:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
Message-ID: <20080711003258.GA23143@martell.zuzino.mipt.ru>
References: <1208904967.17117.51.camel@nimitz.home.sr71.net> <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu> <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz> <20080710173246.GA1857@us.ibm.com> <m163rd1sd5.fsf@frodo.ebiederm.org> <1215716794.9398.41.camel@nimitz> <m14p6xy27s.fsf@frodo.ebiederm.org> <1215719252.9398.53.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215719252.9398.53.camel@nimitz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:47:32PM -0700, Dave Hansen wrote:
> On Thu, 2008-07-10 at 12:21 -0700, Eric W. Biederman wrote:
> > > Are we talking about the VMA itself, or the memory backing the VMA?
> > 
> > The memory backing the VMA.  We need to store the page protections
> > that the memory was mapped with as well now that you point it out.  A
> > VMA is not user space visible, which is why we can arbitrarily split
> > and merge VMAs.
> 
> It is visible with /proc/$pid/{maps,smaps,numamaps?}.  That's the only
> efficient way I know of from userspace to figure out where userspace's
> memory is and if it *is* file backed, and what the permissions are.

None of those files exist if PROC_FS is off.

> We also can't truly split them arbitrarily because the memory cost of
> the VMAs themselves might become too heavy (the remap_file_pages()
> problem).
> 
> It gets trickier when things are also private mappings in addition to
> being in a file-backed VMA.  We *do* need to checkpoint those, but only
> the pages to which there was a write.
> 
> There's also the problem of restoring things read-only, but VM_MAYWRITE.
> If there's a high level of (non-COW'd) sharing of these anonymous areas,
> we may not be able to even restore the set of processes unless we can
> replicate the sharing.  We might run out of memory if the sharing isn't
> replicated.

