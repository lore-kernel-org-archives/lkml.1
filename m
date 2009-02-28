Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZB1Uxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZB1Uxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZB1Uxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:53:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33268 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZB1Uxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:53:39 -0500
Date: Sat, 28 Feb 2009 15:53:29 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
Message-ID: <20090228205329.GB4254@infradead.org>
References: <20090227203425.F3B51176@kernel> <20090227203431.D1E697CB@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203431.D1E697CB@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:34:31PM -0800, Dave Hansen wrote:
> 
> We have set up sane defaults for how filesystems should
> be checkpointed.  However, as usual in the VFS, there
> are specialized places that will always need an ability
> to override these defaults.
> 
> This adds a new 'file_operations' function for
> checkpointing a file.  I did this under the assumption
> that we should have a dirt-simple way to make something
> (un)checkpointable that fits in with current code.
> 
> As you can see in the /dev/null patch in a second, all
> that we have to do to make something like /dev/null
> supported is add a single "generic" f_op entry.

Please don't do the fallback to allow checkpointing without file
operations.  We've never had luck with these fallbacks, and I'm
in the process of getting of the last default file operation (llseek,
which has a very bad default) currently.

Incidentally that should also allow you to get rid of the per-fs flag
by just checking for the presence of the operation to check if
checkpointing is allowed.

Also the double-use of the op seem not very nice to me.  Is there any
real life use case were you would have the operation on a file but
sometimes not allow checkpoiting?

