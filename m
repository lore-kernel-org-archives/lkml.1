Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbXHITIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbXHITIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXHITIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:08:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbXHITIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:08:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0708091143440.19611@us.intercode.com.au>
References: <Pine.LNX.4.64.0708091143440.19611@us.intercode.com.au> <162335.27499.qm@web36605.mail.mud.yahoo.com>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, Casey Schaufler <casey@schaufler-ca.com>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       trond.myklebust@fys.uio.no, linux-fsdevel@vger.kernel.org,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/14] CacheFiles: Permit an inode's security ID to be obtained [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 20:07:39 +0100
Message-ID: <22259.1186686459@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> David, I've looked at the code and can't see that you need to access the 
> label itself outside the LSM.  Could you instead simply pass the inode 
> pointer around?

It's not quite that simple.  I need to impose *two* security labels in
cachefiles_begin_secure() when I'm about to act on behalf of a process that's
tried to access a netfs file:

 (1) The security label to act as.  This is the label attached to the
     cachefilesd process when it starts the cache.  This is obtained by
     cachefiles_get_security_ID().

 (2) The security label to create files as.  This is the label attached to
     root directory of the cache.  This is obtained by
     cachefiles_determine_cache_secid().

David
