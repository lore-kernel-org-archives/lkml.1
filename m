Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZADIII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZADIII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZADIHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:07:53 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56069 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbZADIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:07:53 -0500
Date: Sun, 4 Jan 2009 09:09:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Message-ID: <20090104080931.GA31198@uranus.ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901031346.01325.rob@landley.net> <20090103201059.GA4875@uranus.ravnborg.org> <200901031945.35163.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901031945.35163.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 07:45:34PM -0600, Rob Landley wrote:
> > With respect to your three patches the plan is to:
> > - add the updated timeconst patch to kbuild-next
> > - add the updated cpu-feature patch to kbuild-next
> >
> > - the patch touching headers_install will not be merged.
> >   The way forward for headers_install is to combine the
> >   unifdef feature and the header modifications.
> 
> Since you're turning down an existing patch in favor of a theoretical patch, I 
> assume you have plans to do this yourself?

If noone else beats me I will do so - yes.
> 
> >   And this must be in a single program that can process
> >   all headers in one go so the install process becomes so fast
> >   that we do not worry about if it was done before or not.
> >   Then we can avoid all the .* files in the directory
> >   where we isntall the headers.
> 
> What if they run out of disk space halfway through writing a file and thus it 
> creates a short file (or a 0 length file where the dentry was created but no 
> blocks could be allocated for the write)?

Then they fail and make will know. Then may leave a file or 100
but it still failed. At next run everything will be done right
assuming the culprint has been fixed.

> I can try to make the shell version more readable, and more powerful.  It's 
> already noticeably faster than the perl version.  I have no objections to 
> making unifdef do all of this, I just haven't got any interest either.

I have no interest in merging a shell version.
I clearly expressed above that we need a _single_ program doing
all of the preparations and we do not need a reimplmentatio of the
current headers_install.
I also explained why.

	Sam
