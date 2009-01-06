Return-Path: <linux-kernel-owner+w=401wt.eu-S1756849AbZAFXof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbZAFXof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZAFXnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:43:47 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:51760 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbZAFXnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:43:45 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <1231283935.14345.142.camel@localhost>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com>  <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <1231283935.14345.142.camel@localhost>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 18:43:37 -0500
Message-Id: <1231285417.8041.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 7A6D40FBF67D2DAA2547B374A705FD2CBE7C0B63
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 3 total 330 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 15:18 -0800, Matt Helsley wrote:
> Yes, I was aware that the inode might be dirtied by another container. I
> was thinking that, at least in the case of NFS, it makes sense to report
> the node name of the container that did the original mount. Of course
> this doesn't address the general RPC client case and, like patch 3, it
> makes the superblock solution rather NFS-specific. That brings me to a
> basic question: Are there any RPC clients in the kernel that do not
> operate on behalf of NFS?

Yes. There is, for instance, the portmapper/rpcbind client. The NFS and
lockd servers also sometime needs to send RPC callbacks. Assuming that
you can convert the RPC client into something NFS-specific is therefore
not an option.

Trond

