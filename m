Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbXCEXtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbXCEXtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:49:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXCEXtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:49:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:39770 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622AbXCEXtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:49:11 -0500
From: Neil Brown <neilb@suse.de>
To: Olaf Kirch <olaf.kirch@oracle.com>
Date: Tue, 6 Mar 2007 10:47:53 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17900.44073.791834.143726@notabene.brown>
Cc: nfs@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 001 of 3] knfsd: Use recv_msg to get peer address for NFSD instead of code-copying
In-Reply-To: message from Olaf Kirch on Monday March 5
References: <20070302151748.5226.patches@notabene>
	<1070302042825.5760@suse.de>
	<200703051953.24900.olaf.kirch@oracle.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday March 5, olaf.kirch@oracle.com wrote:
> On Friday 02 March 2007 05:28, NeilBrown wrote:
> > The sunrpc server code needs to know the source and destination address
> > for UDP packets so it can reply properly.
> > It currently copies code out of the network stack to pick the pieces out
> > of the skb.
> > This is ugly and causes compile problems with the IPv6 stuff.
> 
> ... and this IPv6 code could never have worked anyway:

:-(
It's hard to test the IPv6 server until we have an IPv6 client I
guess, so thanks for the code review, even though we aren't going to
end up using that code...

> 
> But I find using recvmsg just for getting at the addresses
> a little awkward too.

Do you?  It's surely a lot better than code duplication, and it is
exactly how you would get the information from user-space.

>                       And I think to be on the safe side, you
> should check that you're really looking at a PKTINFO cmsg
> rather than something else.

Maybe.....
But is there really a chance that it might not be PKTINFO?
And what do you do if it isn't?
Log an error and drop the packet I guess.

I'll see what I can do.

NeilBrown
