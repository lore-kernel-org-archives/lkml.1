Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbYJJLvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbYJJLvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 07:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754518AbYJJLvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 07:51:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:20499 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYJJLvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 07:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=vRrncVfDrqS/aWGHjLYTUHAAMWK9l7beFQfEvW8sKeaNodZQESB0aYQjzflNToS1K2
         lEUVmuablVAFP189f7QyjpDCyU1uJBE8BzuA46gtOb3GnB3AqobyacwDraWe500CPhcn
         nDjLSl453CFyX3KWiGX5rcNrQXAqYR51hm4DQ=
Date: Fri, 10 Oct 2008 14:51:44 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: zanussi@comcast.net, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
Message-ID: <20081010115144.GB5221@localhost>
References: <20080923212914.GB5237@localhost> <1223386477.28348.42.camel@penberg-laptop> <1223623191.8959.26.camel@penberg-laptop> <1223628687.8959.37.camel@penberg-laptop> <1223629803.8959.40.camel@penberg-laptop> <1223631723.8959.46.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223631723.8959.46.camel@penberg-laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 12:42:03PM +0300, Pekka Enberg wrote:
> (I'm cc'ing Tom, Jens, and LKML.)
> 
> On Fri, 2008-10-10 at 12:10 +0300, Pekka Enberg wrote:
> > > I'm seeing a hard lock on my machine when I run kmemtraced with the
> > > following patch applied:
> > > 
> > > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=17ca1d5506b1db433f0b7167a627bfd55d319dd3
> > > 
> > > I can enable/disable kmemtrace via the debugfs files fine and can also
> > > read the relay files with cat.
> > > 
> > > Any idea where this is coming from?
> > 
> > OK, it's the first splice() call in reader_thread() that causes the
> > hang. Hmm.
> 
> To recap, with a CONFIG_KMEMTRACE enabled kernel from the
> "topic/kmemtrace" branch of:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git topic/kmemtrace
> 
> running the "kmemtraced" program from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/kmemtrace-user.git
> 
> results to a hard lock on my machine. I am unable to find anything
> obviously wrong with it and as I can read/write the relay files just
> fine, I'm beginning to think it's problem in relayfs splice
> implementation.
> 
> Tom, thoughts?
> 
> 		Pekka
>

Hmm, I've seen kmemtraced not stopping, but no hard locks. It seems not
even SIGKILL can stop it. As far as I know, SIGKILL should stop even a
blocking splice() (in case this is the problem). This is what I did:
# ./kmemtraced &
# killall -KILL kmemtraced
... kmemtraced still running and using CPU.


	Eduard

