Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZEaVy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZEaVy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 17:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZEaVyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 17:54:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3553 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbZEaVyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 17:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X/Et/by8lQJYnDJht8FxRcOfCEBLYnJDdK0sSWTg3ZriLjiorBt1UIJz0897wVUcKc
         GD+nw4fLrkOveYi4gqP8c2fosffXcHGS8xzuEGnc8+t23DSl1mMYzem9p4njLW9saUP2
         o4Z2rJyXQy+DQmTRLmd6Qwjj9qvsaBriOcBnc=
Date: Mon, 1 Jun 2009 01:54:27 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, mingo@elte.hu, torvalds@linux-foundation.org
Subject: Re: [PATCH 14/38] Remove struct mm_struct::exe_file et al
Message-ID: <20090531215427.GA29534@x200.localdomain>
References: <20090526113618.GJ28083@us.ibm.com> <20090526162415.fb9cefef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526162415.fb9cefef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:24:15PM -0700, Andrew Morton wrote:
> On Tue, 26 May 2009 04:36:18 -0700
> Matt Helsley <matthltc@us.ibm.com> wrote:
> 
> > I don't see any mention in the changelog of the point brought up by Ingo:
> > 
> > http://lkml.org/lkml/2009/4/10/105
> 
> Nor of Eric's comments.
> 
> Alexey, pleeeze don't do this.  We (read: I) heavily depend upon patch
> submitters to keep track of outstanding issues and review comments,
> etc.
> 
> If the patch submitter simply blows these things off then it devolves
> to me having to keep track of each patch's issue list as well as the
> patch itself.  My workload goes up by a factor of N and the error rate
> goes up by N^2 :(

grmbh..

"Security" and "holding ->mmap_sem" were answered and dismissed.

You can't do readlink(2) on /proc/*/exe if you can't ptrace task.
So no new possible holes are created.

->mmap_sem was held since /proc/*/exe was added and nobody cared.
And, again, you can't readlink _any_ /proc/*/exe.

Patch simply restores code to year-back state.

I'll send removal and readddition of "struct path" as separate things
next time.


And BTW, there is something unnatural when executable path is attached
to mm_struct(!) not task_struct, so yet another argument to ->exe_file
removal.
