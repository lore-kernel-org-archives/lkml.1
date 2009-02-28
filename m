Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbZB1Vh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbZB1Vh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZB1VhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:37:12 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38823 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbZB1VhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:37:10 -0500
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20090228205329.GB4254@infradead.org>
References: <20090227203425.F3B51176@kernel>
	 <20090227203431.D1E697CB@kernel>  <20090228205329.GB4254@infradead.org>
Content-Type: text/plain
Date: Sat, 28 Feb 2009 13:37:06 -0800
Message-Id: <1235857026.26788.421.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 15:53 -0500, Christoph Hellwig wrote:
> On Fri, Feb 27, 2009 at 12:34:31PM -0800, Dave Hansen wrote:
> > We have set up sane defaults for how filesystems should
> > be checkpointed.  However, as usual in the VFS, there
> > are specialized places that will always need an ability
> > to override these defaults.
> > 
> > This adds a new 'file_operations' function for
> > checkpointing a file.  I did this under the assumption
> > that we should have a dirt-simple way to make something
> > (un)checkpointable that fits in with current code.
> > 
> > As you can see in the /dev/null patch in a second, all
> > that we have to do to make something like /dev/null
> > supported is add a single "generic" f_op entry.
> 
> Please don't do the fallback to allow checkpointing without file
> operations.  We've never had luck with these fallbacks, and I'm
> in the process of getting of the last default file operation (llseek,
> which has a very bad default) currently.

You'll probably believe me when I tell you that I was looking at how
lseek was done when I did this. :)

Doing this will make for a much, much bigger patch, but I do understand
why you're asking for it to be done this way, so I'll give it a shot for
the next round.

> Incidentally that should also allow you to get rid of the per-fs flag
> by just checking for the presence of the operation to check if
> checkpointing is allowed.

Yup, I completely agree.  The flag was basically an indicator when it
was OK to do the fallback.

> Also the double-use of the op seem not very nice to me.  Is there any
> real life use case were you would have the operation on a file but
> sometimes not allow checkpoiting?

No, I don't have any good concrete ones.  The first thing that comes to
mind is something like a pipe.  We can checkpoint when there's no data,
but must refuse when there's data in the pipe.  In practice, pipes are
fixable, but it is the kind of situation where I expected it to get
used.

Thanks, Christoph.

-- Dave

