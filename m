Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbXHTX1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbXHTX1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 19:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXHTX1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 19:27:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:55375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbXHTX1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 19:27:13 -0400
From: Neil Brown <neilb@suse.de>
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
Date: Tue, 21 Aug 2007 09:27:06 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18122.9034.504690.370294@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS hang + umount -f: better behaviour requested.
In-Reply-To: message from Robin Lee Powell on Monday August 20
References: <20070820225415.GL3956@digitalkingdom.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 20, rlpowell@digitalkingdom.org wrote:
> (cc's to me appreciated)
> 
> It would be really, really nice if "umount -f" against a hung NFS
> mount actually worked on Linux.  As much as I hate Solaris, I
> consider it the gold standard in this case: If I say
> "umount -f /mount/that/is/hung" it just goes away, immediately, and
> anything still trying to use it dies (with EIO, I'm told).

Have you tried "umount -l"?   How far is that from your requirements?

Alternately:
   mount --move /problem/path /somewhere/else
   umount -f /somewhere/else
   umount -l /somewhere/else

might be a little closer to what you want.

Though I agree that it would be nice if we could convince all
subsequent requests to a server to fail EIO instead of just the
currently active ones.  I'm not sure that just changing "umount -f" is
the right interface though....  Maybe if all the server handles
appeared in sysfs and have an attribute which you could set to cause
all requests to fail...

NeilBrown
