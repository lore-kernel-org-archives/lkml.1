Return-Path: <linux-kernel-owner+w=401wt.eu-S1765386AbXHAPXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765386AbXHAPXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757599AbXHAPXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:23:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53755 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbXHAPXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:23:35 -0400
Subject: Re: [RFC 12/26] ext2 white-out support
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
In-Reply-To: <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
References: <20070730161323.100048969@weierstrass.suse.de>
	 <20070730161324.261652101@weierstrass.suse.de>
	 <20070731163656.GC22350@filer.fsl.cs.sunysb.edu>
	 <20070731170012.GN5101@hasse.suse.de>
	 <20070731171159.GA27234@filer.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Wed, 01 Aug 2007 10:23:29 -0500
Message-Id: <1185981810.18007.14.camel@kleikamp.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-31 at 13:11 -0400, Josef Sipek wrote:
> On Tue, Jul 31, 2007 at 07:00:12PM +0200, Jan Blunck wrote:
> > On Tue, Jul 31, Josef Sipek wrote:
> > 
> > > On Mon, Jul 30, 2007 at 06:13:35PM +0200, Jan Blunck wrote:
> > > > Introduce white-out support to ext2.
> > > 
> > > I think storing whiteouts on the branches is wrong. It creates all sort of
> > > nasty cases when people actually try to use unioning. Imagine a (no-so
> > > unlikely) scenario where you have 2 unions, and they share a branch. If you
> > > create a whiteout in one union on that shared branch, the whiteout magically
> > > affects the other union as well! Whiteouts are a union-level construct, and
> > > therefore storing them at the branch level is wrong.
> > 
> > So you think that just because you mounted the filesystem somewhere else it
> > should look different? This is what sharing is all about. If you share a
> > filesystem you also share the removal of objects.
> 
> The removal happens at the union level, not the branch level. Say you have:
> 
> /a/
> /b/foo
> /c/foo
> 
> And you mount /u1 as a union of {a,b}, and /u2 as union of {a,c}.

Who does this?  I'm assuming that a is the "top" layer.  Aren't union
mounts typically about sharing lower layers and having a separate rw
layer for each union mount?

> $ find /u*
> /u1
> /u1/foo
> /u2
> /u2/foo
> $ rm /u1/foo # this creates whiteout for "foo" in /a
> $ find /u*
> /u1
> /u2
> 
> Is that what you'd expect as a user? I don't think so.

That's exactly what I would expect.

If I were to:
$ echo "this is new" > /u1/foo

I would expect:
$ cat /u2/foo
this is new

So why should rm behave differently?

I haven't really been tuned into union mounts, so maybe I'm missing out
on something basic here.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

