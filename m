Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYCNVAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYCNVAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758117AbYCNVAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:00:00 -0400
Received: from pat.uio.no ([129.240.10.15]:55085 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328AbYCNU77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:59:59 -0400
Subject: Re: [RFC] Union mount readdir support in glibc
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Staubach <staubach@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, drepper@redhat.com,
       viro@ZenIV.linux.org.uk, bharata@linux.vnet.ibm.com,
       libc-alpha@sourceware.org, jblunck@suse.de, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de,
       cmm@us.ibm.com, haveblue@us.ibm.com
In-Reply-To: <47DABBAF.4040005@redhat.com>
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com>
	 <20080314053925.GA10722@ZenIV.linux.org.uk> <47DA257C.9060409@redhat.com>
	 <E1Ja5Tf-0003Op-Fi@pomaz-ex.szeredi.hu>  <47DABBAF.4040005@redhat.com>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 16:58:22 -0400
Message-Id: <1205528302.27906.81.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 171B72F41C23127D43E888FDFDB1F39EDD78A8ED
X-UiO-SR-test: 726B67D273E721CBE9A51FD3EB399464924376EB
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 317 total 7421973 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 13:53 -0400, Peter Staubach wrote:
> Miklos Szeredi wrote:
> >>> Actually, do we really need it other than to 0 and to current position
> >>> (i.e. full rewind and a no-op)?
> >>>       
> >> Ever heard of the little function "telldir"?
> >>     
> >
> > Actually, telldir/seekdir is already broken for some filesystems (NFS
> > comes to mind).  POSIX was really crazy to require a working seekdir
> > implementation, and userspace should quickly start _not_ using it.

POSIX never did require a working seekdir implementation. That
requirement came from our friends in the "Open Group":

   http://www.opengroup.org/onlinepubs/009695399/functions/seekdir.html

> What makes you think that telldir/seekdir don't work for NFS?  The over the
> wire protocols clearly take values which could be retrieved and stored via
> those interfaces.
> 
>        ps

Except for the fact that the NFS cookies are unsigned (and in the case
of NFSv3/v4 are 64-bit wide), whereas glibc gets confused when
confronted with 'negative' telldir values.

Hence the current Linux client's wrapping of the on-the-wire cookies. As
far as I can see, it is fully conformant with the spec, which has the
perfect "get out of jail free" card:

        "The definition of seekdir() and telldir() does not specify
        whether, when using these interfaces, a given directory entry
        will be seen at all, or more than once."

  Trond

