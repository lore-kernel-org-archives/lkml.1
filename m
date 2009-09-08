Return-Path: <linux-kernel-owner+w=401wt.eu-S1751436AbZIHQJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbZIHQJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750847AbZIHQJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:09:27 -0400
Received: from kroah.org ([198.145.64.141]:57940 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZIHQJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:09:26 -0400
Date: Tue, 8 Sep 2009 09:06:58 -0700
From: Greg KH <greg@kroah.com>
To: Joe Peterson <joe@skyrush.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tty tree with the  tree
Message-ID: <20090908160658.GA4739@kroah.com>
References: <20090907191347.fe010955.sfr@canb.auug.org.au>
 <alpine.LFD.2.01.0909071104340.25628@localhost.localdomain>
 <4AA58160.7080908@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AA58160.7080908@skyrush.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07, 2009 at 03:55:44PM -0600, Joe Peterson wrote:
> Linus Torvalds wrote:
> > Hmm. I think that the "honor opost flag for echoes" patch is actually 
> > wrong.
> > 
> > We check O_OPOST() in the _caller_ for the regular write case, and that
> > test actually looks like this:
> > 
> > 	if (O_OPOST(tty) && !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
> > 
> > so at a minimum, if we add it to process_output() we should likely add it 
> > in the same format. But if we need that test, I'd rather do it in the 
> > caller anyway, like we already do for regular writes.
> 
> Yes, very true.  The old opost() function also contained the O_OPOST
> check (i.e. causing a double check for normal writes), and you are right
> that we should not reintroduce it (and it makes sense for the caller to
> check it).
> 
> There is only the one case in which the O_OPOST check is needed before
> calling do_output_char() (in process_echoes()), so we could just inline
> the test there.  Take a look at my new attached patch (untested also).
> I'll test and resubmit, assuming there are no objections.

Thanks for doing this, I'll drop the patch from my tree and wait for you
to test and resubmit this.

thanks,

greg k-h
