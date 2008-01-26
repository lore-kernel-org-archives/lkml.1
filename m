Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbYAZAPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbYAZAPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYAZAPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:15:14 -0500
Received: from mail.fieldses.org ([66.93.2.214]:50920 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbYAZAPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:15:11 -0500
Date: Fri, 25 Jan 2008 19:15:10 -0500
To: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org
Cc: linux-kernel@vger.kernel.org
Subject: nfs server patches not in 2.6.25
Message-ID: <20080126001510.GH25141@fieldses.org>
References: <20080125231521.GG25141@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080125231521.GG25141@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some idea what we might be working on for 2.6.26, besides continued
bug-fixing and cleanup:

Work that we already have patches for and that I expect to be included
in whole or in 2.6.26:

	- ipv6: Aurélien Charbon's patch to add ipv6 support to the
	  server's export interface is ready.  I'm not clear what else
	  remains for full ipv6 support.
	- failover and migration: Wendy Cheng's patches appear to be in
	  good shape, so I expect them or something with equivalent
	  functionality to be in 2.6.26.
	- gss callbacks: We have patches to add support for rpcsec_gss
	  on NFSv4's callback channel (allowing us to support
	  delegations on kerberos mounts), but they've been put on hold
	  pending improvements to the client's gssd upcall.  I hope to
	  get back to that work in the next few weeks.

Also in progress:

	- spkm3 and future gss mechanisms may generate context
	  initiation rpc's that are very large.  Olga Kornievskaia and I
	  have been working on fixing the server gssd interfaces to
	  permit this.

	- There are some mismatches between the semantics required for
	  nfsv4 delegations and what Linux's lease subsystem provides
	  us.  David Richter and I have done a little work on this.  We
	  need to start submitting it.

Three items I identified previously as issues I'd like fixed before we
removed the dependency of CONFIG_NFSD_V4 on CONFIG_EXPERIMENTAL:

	http://linux-nfs.org/pipermail/nfsv4/2006-December/005497.html

	- export paths consistent between v2/v3/v4:  We have some code
	  that fixes this entirely in userspace.  That approach doesn't
	  provide stable filehandles in the NFSv4 pseudofilesystem, and
	  there seems to be a general sentiment that it's overly
	  complicated.  It has the one advantage that we don't have to
	  commit to it, since it uses only existing kernel interfaces.
	  So I think we're probably going to apply that to nfs-utils as
	  a stopgap measure and start work on fixing this in the kernel
	  at the same time....

	- reboot recovery: there have been complaints about the
	  server-side nfsv4 reboot recovery code for a while, we've had
	  code that tries to fix it for a while, and it just hasn't
	  happened.  I'm hoping we can finally get this ready for
	  2.6.26.

	- export security: this was finished in 2.6.23; we now support
	  export options like sec=krb5:krb5i:krb5p, which have a few
	  advantages over the special gss/krb5 client names.  This could
	  be better documented, though.

I've probably left a lot out.  Let me know of ongoing projects and
todo's that I've forgotten....

--b.
