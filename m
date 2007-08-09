Return-Path: <linux-kernel-owner+w=401wt.eu-S938783AbXHIL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938783AbXHIL40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762413AbXHIL4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:56:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937323AbXHIL4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:56:04 -0400
Date: Thu, 9 Aug 2007 07:55:02 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com,
       jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz,
       reiserfs-devel@vger.kernel.org, zippel@linux-m68k.org, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org, wli@holomorphy.com,
       joel.becker@oracle.com, dhowells@redhat.com,
       fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
       user-mode-linux-user@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       linux-ext4@vger.kernel.org, linux-cifs-client@lists.samba.org,
       ocfs2-devel@oss.oracle.com, bfennema@falcon.csc.calpoly.edu
Subject: Re: [fuse-devel] [PATCH 00/25] move handling of setuid/gid bits
 from VFS into individual setattr functions (RESEND)
Message-Id: <20070809075502.b3426ce9.jlayton@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<20070808085435.722f2b10.jlayton@redhat.com>
	<20070808094853.8c27450c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708082204210.10387@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 22:05:13 +0200 (CEST)
Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Aug 8 2007 09:48, Andrew Morton wrote:
> >> > On Mon, 6 Aug 2007 09:54:03 -0400
> >> > Jeff Layton <jlayton@redhat.com> wrote:
> >> > 
> >> > Is there any way in which we can prevent these problems?  Say
> >> > 
> >> > - rename something so that unconverted filesystems will reliably fail to
> >> >   compile?
> >> > 
> >> 
> >> I suppose we could rename the .setattr inode operation to something
> >> else, but then we'll be stuck with it for at least a while. That seems
> >> sort of kludgey too...
> >
> >Sure.  We're changing the required behaviour of .setattr.  Changing its
> >name is a fine and reasonably reliable way to communicate that fact.
> 
> Maybe ->chattr/->chgattr?
> 
> 

That seems like a good replacement name. :-)

Now that I think on this further though, maybe Trond's suggestion to
change how the return code works is the best one. That would
(hopefully) catch this problem at runtime, so if someone is using a
precompiled but unconverted module then that would be detected too.

--
Jeff Layton <jlayton@redhat.com>
