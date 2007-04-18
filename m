Return-Path: <linux-kernel-owner+w=401wt.eu-S2992717AbXDRPBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992717AbXDRPBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992715AbXDRPBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:01:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33590 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992711AbXDRPBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:01:44 -0400
Date: Wed, 18 Apr 2007 16:01:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Miklos Szeredi <miklos@szeredi.hu>, ebiederm@xmission.com,
       serue@us.ibm.com, linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, containers@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Devel] Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
Message-ID: <20070418150110.GA29815@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Miklos Szeredi <miklos@szeredi.hu>, ebiederm@xmission.com,
	serue@us.ibm.com, linuxram@us.ibm.com,
	linux-fsdevel@vger.kernel.org, viro@ftp.linux.org.uk,
	containers@lists.osdl.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070416195652.GA350@sergelap.austin.ibm.com> <m1k5wbjrsh.fsf@ebiederm.dsl.xmission.com> <E1HdlYr-00015O-00@dorka.pomaz.szeredi.hu> <m1zm56j27m.fsf@ebiederm.dsl.xmission.com> <E1HdsX6-0002Kl-00@dorka.pomaz.szeredi.hu> <m1vefuixp5.fsf@ebiederm.dsl.xmission.com> <E1He6C7-0003Xu-00@dorka.pomaz.szeredi.hu> <1176904505.6796.79.camel@heimdal.trondhjem.org> <E1HeAkl-000490-00@dorka.pomaz.szeredi.hu> <1176906389.6796.96.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176906389.6796.96.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 10:26:29AM -0400, Trond Myklebust wrote:
> > That doesn't really change my agrument though.  _If_ the flag is per
> > mount, then it makes sense to be able to change it on a master and not
> > on a slave.  If mount flags are propagated, this is not possible.
> 
> Read-only isn't the only issue. On something like NFS, there are flags
> to set the security flavour, turn on/off encryption etc.
> 
> If I mount your home directory using no encryption in my namespace, for
> instance, then neither you nor the administrator will be able to turn it
> on afterwards in yours without first unmounting it from mine so that the
> superblock is destroyed.

I suspect the right answer here is to make nfs mount handling smarter.
The way mounting works the filesystem is allowed to choose whether it
can re-used a superblock or needs a new one.  In the NFS case we probably
want to allow multiple superblocks for the same export if important
paramaters like the security model mismatch.

This is however only the technical part of the answer.  There's a more
important one, and that's the user experience - we need a much better
way to document which flags are per-superblock and which are per-mount.

Due to this and some other issues we'll probably need a new mount API
in some time.
