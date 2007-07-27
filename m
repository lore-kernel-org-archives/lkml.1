Return-Path: <linux-kernel-owner+w=401wt.eu-S933880AbXG0Bin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933880AbXG0Bin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbXG0Bih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:38:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34911 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbXG0Big (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:38:36 -0400
Date: Fri, 27 Jul 2007 02:38:35 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockd and nfsd endianness annotation fixes
Message-ID: <20070727013835.GR27237@ftp.linux.org.uk>
References: <E1IE6Hd-0005Dl-Hu@ZenIV.linux.org.uk> <20070726220853.GN8125@fieldses.org> <18089.14397.946323.617318@notabene.brown> <20070727011922.GC27538@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070727011922.GC27538@fieldses.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 09:19:22PM -0400, J. Bruce Fields wrote:
 
> Thanks, uh, I probably saw that message too.
> 
> Hm, trying it just now--it catches the svclock.c mistake, but not the
> one in nfsd/nfs4xdr.c--at least not as far as I can tell.

fs/nfsd/nfs4xdr.c:2659:32: warning: incorrect type in argument 2 (different base types)
fs/nfsd/nfs4xdr.c:2659:32:    expected int [signed] nfserr
fs/nfsd/nfs4xdr.c:2659:32:    got restricted unsigned int [usertype] status

is what got triggered.  I.e. call in
        case OP_SECINFO:
                nfsd4_encode_secinfo(resp, op->status, &op->u.secinfo);
                break;
which pointed to the misannotated function...
