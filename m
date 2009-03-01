Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZCAPTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZCAPTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 10:19:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbZCAPTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 10:19:32 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52965 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZCAPTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 10:19:32 -0500
Date: Sun, 1 Mar 2009 09:19:28 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [RFC][PATCH 5/8] add f_op for checkpointability
Message-ID: <20090301151928.GB18867@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203431.D1E697CB@kernel> <20090228205329.GB4254@infradead.org> <1235857026.26788.421.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235857026.26788.421.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > Also the double-use of the op seem not very nice to me.  Is there any
> > real life use case were you would have the operation on a file but
> > sometimes not allow checkpoiting?
> 
> No, I don't have any good concrete ones.  The first thing that comes to
> mind is something like a pipe.  We can checkpoint when there's no data,
> but must refuse when there's data in the pipe.  In practice, pipes are
> fixable, but it is the kind of situation where I expected it to get
> used.

Hmm, but that's the kind of thing Ingo is resolutely against,
right?  If you've opened some resource that may in certain
cases not be checkpointable, then checkpointing it in certain
states is just wrong, as the app can never know for sure (without
knowing the fragile and temporary implementation details)
whether it is checkpointable.

So we either support pipes or we don't.

(Now maybe you have another use in mind for it...)

-serge
