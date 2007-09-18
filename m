Return-Path: <linux-kernel-owner+w=401wt.eu-S1761716AbXIRSER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761716AbXIRSER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760650AbXIRSEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:04:01 -0400
Received: from pat.uio.no ([129.240.10.15]:35009 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761627AbXIRSEA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:04:00 -0400
Subject: Re: Credentials test patch
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: casey@schaufler-ca.com
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <336243.38765.qm@web36610.mail.mud.yahoo.com>
References: <336243.38765.qm@web36610.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 18 Sep 2007 14:03:41 -0400
Message-Id: <1190138621.6656.39.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.023)
X-UiO-Scanned: 875FE11D18712BEF9EE5317BFDFAC745133B2168
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 75 total 3955212 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 10:58 -0700, Casey Schaufler wrote:
> --- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Tue, 2007-09-18 at 17:33 +0100, David Howells wrote:
> > > Hi Al, Christoph,
> > > 
> > > Here's a new version of my credentials patch.  It's still very basic, with
> > > only Ext3, (V)FAT, NFS, AFS, SELinux and keyrings compiled in on an x86_64
> > > arch kernel.  The patched kernel compiles, links and runs.
> > > 
> > > I've made the following major changes to the patch:
> > > 
> > >  (1) System calls that might want to use the credentials call
> > >      update_current_cred() before calling into the VFS or whatever.  This
> > >      allows the keyring pointers in the cred struct to be updated.
> > > 
> > >  (2) I've got rid of current_cred(), __current_cred() and the accessors for
> > >      current's fsuid, fsgid and group list.  Instead you just use
> > >      current->cred->whatever.  You don't need RCU to read the current
> > threads
> > >      credentials as only you are permitted to change them.
> > > 
> > > David
> > > ---
> > 
> > What about the process' capabilities? Shouldn't they also be part of a
> > credential?
> 
> As should the LSM security blob, if appropriate.
> 
> What I don't really understand is what value is gained by this exercise.
> Are the savings sufficiently significant to justify the effort?

It is not about savings, but about new functionality. Basically, the
existence of reference-counted credentials will allow AFS and NFS to
cache that information and use it for deferred writes etc.

Cheers
  Trond

