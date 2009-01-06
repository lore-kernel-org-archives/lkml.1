Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbZAFNFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbZAFNFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZAFNFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:05:07 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:33562 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZAFNFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:05:05 -0500
Subject: Re: [RFC][PATCH 4/4] Represent RPC Callers
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
In-Reply-To: <20090106011315.229045829@us.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011315.229045829@us.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 08:04:22 -0500
Message-Id: <1231247062.7127.36.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: EEFFCDC6B3E4D030D386355646C9CD6A39F75C33
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 322 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 17:13 -0800, Matt Helsley wrote:
> plain text document attachment (move-rpc-client-nodename-cache.patch)
> Currently RPC needs to know the nodename (often the same as the hostname) which
> should be used for UNIX-style authentication and file-lock tracking. Because
> hostname can change between RPC calls and some sequences of RPC calls may
> require consistent names between calls RPC currently saves the nodename with
> the RPC client structure.
> 
> This is doesn't always work because RPC clients may be discarded over the
> lifetime of a higher level service -- like those that compose NFS. Specifically
> this is known to happen during shutdown.
> 
> Hence RPC should expect the nodename to be saved by the caller when sequences
> of RPC calls requiring consistent nodenames may be needed (e.g. NFS). To enable
> this we introduce an RPC caller structure that allows RPC to query the caller
> for this information.
> 
> This patch is not complete but is meant to indicate the direction I'm planning
> on going. I'd like to know if there are any objections or if anyone sees a
> better way to handle this.

You're planning on slowing down every RPC call in order to fix a problem
on client shutdown? Why?

Trond

