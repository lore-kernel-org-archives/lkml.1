Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbZHDVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbZHDVB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbZHDVB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:01:26 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:38835 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648AbZHDVBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:01:25 -0400
Date: Tue, 4 Aug 2009 16:01:01 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 4/6] KEYS: Add garbage collection for dead, revoked and
	expired keys.
Message-ID: <20090804210101.GB13499@us.ibm.com>
References: <20090804184334.GC8442@us.ibm.com> <20090804145530.17676.24656.stgit@warthog.procyon.org.uk> <20090804145546.17676.98776.stgit@warthog.procyon.org.uk> <5007.1249417827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5007.1249417827@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > These two lines (repeated below) beg for a helper?
> 
> Yeah...  Seems reasonable.
> 
> > Can this happen?  This implies that the number of live keys
> > went up, but we're under keyring->sem?
> 
> An expired key can be updated back to life:
> 
> 	[root@andromeda ~]# keyctl  add user a a @s
> 	619170185
> 	[root@andromeda ~]# keyctl timeout 619170185 5
> 	[root@andromeda ~]# keyctl  show
> 	Session Keyring
> 	       -3 --alswrv      0     0  keyring: _ses
> 	627083299 --alswrv      0    -1   \_ keyring: _uid.0
> 	619170185 --alswrv      0     0   \_ user: a
> 	[root@andromeda ~]# keyctl  show
> 	Session Keyring
> 	       -3 --alswrv      0     0  keyring: _ses
> 	627083299 --alswrv      0    -1   \_ keyring: _uid.0
> 	619170185: key inaccessible (Key has expired)
> 	[root@andromeda ~]# keyctl  add user a a @s
> 	619170185
> 	[root@andromeda ~]# keyctl  show
> 	Session Keyring
> 	       -3 --alswrv      0     0  keyring: _ses
> 	627083299 --alswrv      0    -1   \_ keyring: _uid.0
> 	619170185 --alswrv      0     0   \_ user: a

This won't require keyring->sem?

> > > +		.data = &key_gc_delay,
> > 
> > I see where this variable is defined at top of the patch, but
> > I don't see where it is actually used?
> 
> Bah!  I forgot to add gc.c to the mix.  Sorry about that.
> 
> David
