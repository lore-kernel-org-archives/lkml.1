Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXKLWI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXKLWI7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 17:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbXKLWIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 17:08:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:54525 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbXKLWIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 17:08:50 -0500
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@citi.umich.edu>
Date: Tue, 13 Nov 2007 09:08:42 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18232.52970.213438.902011@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: nfsd bugfixes
In-Reply-To: message from J. Bruce Fields on Monday November 12
References: <1194901503-23105-1-git-send-email-bfields@citi.umich.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday November 12, bfields@citi.umich.edu wrote:
> The following two patches are nfsd bugfixes that I believe are
> appropriate for 2.6.24 and 2.6.23.y.
> 
> --b.
> 

Both
  Reviewed-By: NeilBrown <neilb@suse.de>

Calling nfsd_setuser an extra time does open us up for a very tiny
possibility of an ENOMEM at an awkward time.
We could remove that entirely for NFSEXP_ALLSQUASH by allocating an
empty group_info at export time and just using a reference to that.
It would be more awkward to pre-allocate for the NFSEXP_ROOTSQUASH
case as the group_info has to be at least as big as the one in the RPC
request, and would could need a different one of each concurrent
request.... not sure if that is worth "fixing".

Thanks,
NeilBrown
