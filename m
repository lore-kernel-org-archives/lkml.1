Return-Path: <linux-kernel-owner+w=401wt.eu-S1764430AbYBZToW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764430AbYBZToW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYBZToL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:44:11 -0500
Received: from phunq.net ([64.81.85.152]:35707 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750905AbYBZToI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:44:08 -0500
From: Daniel Phillips <phillips@phunq.net>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 00/37] Permit filesystem local caching
Date: Tue, 26 Feb 2008 11:43:27 -0800
User-Agent: KMail/1.9.5
Cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <200802260226.26984.phillips@phunq.net> <24873.1203991250@redhat.com> <27528.1204036418@redhat.com>
In-Reply-To: <27528.1204036418@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802261143.28348.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 06:33, David Howells wrote:
> > Suppose one were to take a mundane approach to the persistent cache
> > problem instead of layering filesystems.  What you would do then is
> > change NFS's ->write_page and variants to fiddle the persistent
> > cache
> 
> It is a requirement laid down by the Linux NFS fs maintainers that the writes
> to the cache be asynchronous, even if the writes to NFS aren't.

As it happens, I will be hanging out for the next few days with said
NFS maintainers, it would help to be as informed as possible about
your patch set.

> Note further that NFS's write_page() != writing to the cache.  Writing to the
> cache is typically done by NFS's readpages().

Yes, of course.  But also by ->write_page no?

> > Which I could eventually find out by reading all the patches but asking you
> > is so much more fun :-)
> 
> And a waste of my time.  I've provided documentation in the main FS-Cache
> patch, both as text files and in comments in header files that answer your
> questions.  Please read them first.

37 Patches, none of which has "Documentation" in the subject line, and
you did not provide a diffstat in patch 0 for the patch set as a whole.
If I had known it was there of course I would have read it.  It is great
to see this level of documentation.  But I do not think it is fair to
blame your (one) reader for missing it.

See the smiley above?  The _real_ reason I am asking you is that I do
not think anybody understands your patch set, in spite of your
considerable efforts to address that.  Discussion in public, right or
wrong, is the only way to fix that.  It is counterproductive to drive
readers away from the discussion for fear that they may miss some point
obvious to the original author, or perhaps already discussed earlier on
lkml, and get flamed for it.

Obviously, the patch set is not going to be perfect when it goes in and
it would be a silly abuse of the open source process to require that,
but the parts where it touches the rest of the system have to be really
well understood, and it is clear from the level of participation in the
thread that they are not.

One bit that already came out of this, which you have alluded to
several times yourself but somehow seem to keep glossing over, is that
you need a ->direct_bio file operations method.  So does loopback mount.
It might be worth putting some effort into seeing how ->direct_IO can
be refactored to make that happen.  You can get it in separately on the
basis of helping loopback, and it will make your patches nicer.

Daniel
