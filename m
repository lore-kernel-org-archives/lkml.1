Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYB2Nb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYB2Nb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 08:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbYB2Nbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 08:31:46 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:44021 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbYB2Nbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 08:31:45 -0500
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr
	name
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Christoph Hellwig <hch@infradead.org>
Cc: casey@schaufler-ca.com, Dave Quigley <dpquigl@tycho.nsa.gov>,
       viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <20080228234850.GA25829@infradead.org>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com>
	 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil>
	 <20080228234850.GA25829@infradead.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 29 Feb 2008 08:31:05 -0500
Message-Id: <1204291865.31790.235.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 18:48 -0500, Christoph Hellwig wrote:
> On Thu, Feb 28, 2008 at 02:30:35PM -0500, Stephen Smalley wrote:
> > This is an interface to be used by NFS to get information from the
> > security module.  The information desired is specific to the MAC
> > labeling functionality in NFSv4 that is being proposed.  That
> > functionality is MAC specific (necessarily so, just like the ACL
> > functionality is ACL specific).  We are hiding the SELinux-specific bits
> > behind the LSM interface, and non-MAC LSMs are free to return NULL in
> > order to indicate that they don't support MAC labeling.  We do NOT want
> > the capability module to return its security blob here, or any other
> > non-MAC LSM - it will yield the wrong semantics for the NFS MAC support.
> 
> I think Casey is totally right here.  The LSM interface should not be
> as specific here.  If you want to limit the NFSv4 interface to single
> MAC xattr label based systems add an additional method to check if
> the LSM is that.  But the proper fix is of course to not add somthing
> so specific to NFSv4 at all, as it's got enough shortcoming already.
> Please add a proper xattr protocol.  It's not like it's hard, SGI
> has been doing this in IRIX for NFSv3 for ages as a sideband protocol,
> and even release the reference source under the GPL.  Just either use
> that with NFSv4 or if you feel fancy merge it into the NFS spec for
> NFSv6^H4.2.
> 
> > In any event, I don't think we need your permission.
> 
> Wow, that's rude even to someone as direct as me.  Casey is the only
> other person having an in-tree LSM, and I think his input in this
> area is important.  But if not I as a VFS person can happily give
> you my "no" for the current version from the VFS point of view.

Fair point - my apologies to Casey.

-- 
Stephen Smalley
National Security Agency

