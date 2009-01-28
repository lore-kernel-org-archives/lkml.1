Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZA1E0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZA1E0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbZA1E0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:26:24 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50000 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbZA1E0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:26:24 -0500
Date: Wed, 28 Jan 2009 05:23:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090128042337.GA15060@redhat.com>
References: <20090115153211.663df310@bike.lwn.net> <20090122065104.2787df2d.akpm@linux-foundation.org> <20090122203248.GA20159@infradead.org> <20090123045646.GK15750@one.firstfloor.org> <20090127165504.53ed7a2d.akpm@linux-foundation.org> <20090128031439.GA11025@redhat.com> <20090127205739.1384343f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127205739.1384343f@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27, Jonathan Corbet wrote:
>
> On Wed, 28 Jan 2009 04:14:39 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I'll try to make the patch tomorrow, but the problem is that I am not
> > sure this is not too ugly.
>
> FWIW, I'm partway through a new attempt using bitops for f_flags, moving
> FASYNC flag handling into fasync_helper(), and doing away with
> additional locks altogether.  I have to get past the publication
> deadline before I can finish it, though.

Great. I'd be happy to agree with another approach.

But please don't forget it is not strictly necessary f_op->fasync()
must use fasync_helper(). And we have users (pipe_rdwr_fasync) which
call fasync_helper() twice.

Oleg.

