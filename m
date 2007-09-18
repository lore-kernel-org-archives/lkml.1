Return-Path: <linux-kernel-owner+w=401wt.eu-S1761328AbXIRR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761328AbXIRR6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759327AbXIRR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:58:44 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:32020 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759474AbXIRR6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:58:43 -0400
X-YMail-OSG: ojg1xKYVM1k8F4SxIrSlKbyVTFiXWwHCwoc9psqxWeIdu0_Nx.1V00CRc4UzwjW3PVg_cc62WA--
X-RocketYMMF: rancidfat
Date: Tue, 18 Sep 2007 10:58:43 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Credentials test patch
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Howells <dhowells@redhat.com>
Cc: viro@ftp.linux.org.uk, hch@infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1190133857.6656.20.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <336243.38765.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Tue, 2007-09-18 at 17:33 +0100, David Howells wrote:
> > Hi Al, Christoph,
> > 
> > Here's a new version of my credentials patch.  It's still very basic, with
> > only Ext3, (V)FAT, NFS, AFS, SELinux and keyrings compiled in on an x86_64
> > arch kernel.  The patched kernel compiles, links and runs.
> > 
> > I've made the following major changes to the patch:
> > 
> >  (1) System calls that might want to use the credentials call
> >      update_current_cred() before calling into the VFS or whatever.  This
> >      allows the keyring pointers in the cred struct to be updated.
> > 
> >  (2) I've got rid of current_cred(), __current_cred() and the accessors for
> >      current's fsuid, fsgid and group list.  Instead you just use
> >      current->cred->whatever.  You don't need RCU to read the current
> threads
> >      credentials as only you are permitted to change them.
> > 
> > David
> > ---
> 
> What about the process' capabilities? Shouldn't they also be part of a
> credential?

As should the LSM security blob, if appropriate.

What I don't really understand is what value is gained by this exercise.
Are the savings sufficiently significant to justify the effort?


Casey Schaufler
casey@schaufler-ca.com
