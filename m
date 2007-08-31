Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXHaJGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXHaJGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 05:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759336AbXHaJGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 05:06:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46661 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758807AbXHaJGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 05:06:04 -0400
X-Sasl-enc: uU+0U2PH3IJvZxo4tBATuOKEUCJMOmMhXGvdPklB+2WR 1188551161
Date: Fri, 31 Aug 2007 17:05:55 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Frank van Maarseveen <frankvm@frankvm.com>
cc: Hua Zhong <hzhong@gmail.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org
Subject: Re: recent nfs change causes autofs regression
In-Reply-To: <20070831081405.GA21499@janus>
Message-ID: <Pine.LNX.4.64.0708311702510.12745@raven.themaw.net>
References: <000701c7eb49$cff701c0$6fe50540$@com> <20070831081405.GA21499@janus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Aug 2007, Frank van Maarseveen wrote:

> On Thu, Aug 30, 2007 at 02:07:43PM -0700, Hua Zhong wrote:
> > I am re-sending this after help from Ian and git-bisect. To me it's a
> > show-stopper: I cannot find an acceptable workaround that I can implement.
> > 
> > The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes several autofs
> > mounts to fail silently - they just not appear when they should.
> > 
> > I believe it's caused by the NFS change that forces multiple mounts from
> > different directories under the same server side filesystem to have the same
> > mount options by default, otherwise it returns EBUSY.
> > 
> > For example, if server has a filesystem /a, and it exports /a/x and /a/y
> > (maybe with rw or ro), and a client must mount /a/x and /a/y with the same
> > mount options now.
> > 
> > Since in my setup they are managed by autofs, and the autofs map is managed
> > by nis, there is no way I could easily workaround it..
> > 
> > If we have to live with this regression, I want to hear some suggestions
> > about how to fix them realistically. Thanks.
> > 
> > By the way, I am not sure if I did the bisect right, but FWIW, git-bisect
> > says:
> > 
> > c98451bdb2f3e6d6cc1e03adad641e9497512b49 is first bad commit
> > commit c98451bdb2f3e6d6cc1e03adad641e9497512b49
> > Author: Frank van Maarseveen <frankvm@frankvm.com>
> > Date:   Mon Jul 9 22:25:29 2007 +0200
> > 
> >     NLM: fix source address of callback to client
> > 
> >     Use the destination address of the original NLM request as the
> >     source address in callbacks to the client.
> > 
> >     Signed-off-by: Frank van Maarseveen <frankvm@frankvm.com>
> >     Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > :040000 040000 675c84bd8b2c50744018becaa0db4aeca19b8f9f
> > 105fbd3cb3fa5e3019836b4b5268125d0181a72d M      fs
> > :040000 040000 0138796e0806b4ebd1cc3850ed4e8c7ab24d2d41
> > 2fec08debe51c20423a88b1a0d4281c683ba5daf M      include
> 
> This does not have any relation with the mount problem, assuming commit
> and comment do match.

That's right.

The commits we're discussing here are (I believe):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=75180df2ed467866ada839fe73cf7cc7d75c0a22
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=275a5d24bf56b2d9dd4644c54a56366b89a028f1

The later being the one returning EBUSY for the option mismatch and the 
former the addition of the "nosharecache" option.

Ian

