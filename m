Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXIJVEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXIJVEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 17:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbXIJVEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 17:04:23 -0400
Received: from pat.uio.no ([129.240.10.15]:58544 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848AbXIJVEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 17:04:22 -0400
Subject: Re: [NFS] [BUG] 2.6.23-rc5 kernel BUG at fs/nfs/nfs4xdr.c:945
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: suzuki <suzuki@in.ibm.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, bfields@fieldses.org,
       neilb@suse.de, nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       ffilz@us.ibm.com, Poornima <bnpoorni@in.ibm.com>
In-Reply-To: <46E4FC2F.6040105@in.ibm.com>
References: <46E121B8.4080105@linux.vnet.ibm.com>
	 <6bffcb0e0709071656o6881fa17y61818a9733293a4c@mail.gmail.com>
	 <1189289549.13713.4.camel@localhost.localdomain>
	 <46E4FC2F.6040105@in.ibm.com>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 23:03:48 +0200
Message-Id: <1189458228.6634.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 5DF4D3080DDE1FBC446F7D8E0EB8C6CB93E9EADF
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 72 total 3781760 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 13:41 +0530, suzuki wrote:
> Hi
> 
> I have been trying to debug this issue from my side and could find the 
> following.
> 
> The pathconf() request gets a reply with :
> 
> pathinfo.max_namelen = (unsiged int) -1
> pathinfo.max_link    = 255
> 
> Is this really an expected answer from a server for a proper connection 
> ( for mount requests on an exported dir) ? Is there something that needs 
> to be fixed at server side ?

I assume that this is with my patch applied? Yes: as long as the kernel
sets NAME_MAX to 255, then the above is expected behaviour.

Trond

