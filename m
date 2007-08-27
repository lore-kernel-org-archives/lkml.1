Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbXH0X04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbXH0X04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 19:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbXH0X0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 19:26:49 -0400
Received: from mail.suse.de ([195.135.220.2]:53655 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbXH0X0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 19:26:48 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Tue, 28 Aug 2007 09:26:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18131.23980.89642.364179@notabene.brown>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH 08/15] knfsd: spawn kernel thread to probe callback channel
In-Reply-To: message from J. Bruce Fields on Monday August 27
References: <11882461763072-git-send-email-bfields@fieldses.org>
	<1188246176681-git-send-email-bfields@fieldses.org>
	<1188246176897-git-send-email-bfields@fieldses.org>
	<1188246177833-git-send-email-bfields@fieldses.org>
	<11882461773576-git-send-email-bfields@fieldses.org>
	<11882461771774-git-send-email-bfields@fieldses.org>
	<1188246177195-git-send-email-bfields@fieldses.org>
	<11882461773396-git-send-email-bfields@fieldses.org>
	<1188246177259-git-send-email-bfields@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday August 27, bfields@fieldses.org wrote:
>  
> +/* Reference counting, callback cleanup, etc., all look racy as heck.
> + * And why is cb_set an atomic? */

Agreed.... so do we really want this code in mainline?  is the old
code so bad that this is better?

 - cb_set should not be atomic.
 - This looks like a job for async-rpc rather than a kernel thread
 - If you do use a thread, you at least want __module_get before
   starting the thread, and module_put_and_exit to terminate the
   thread.
 - Can you just use 'cb_client' rather than cb_set?  If you move
   rpc_create into the thread, you don't need to set cb_client until
   the callback is successful.  Then add a 'cb_active' flag bit
   so that you don't have two callbacks at the same time, and it
   should be less racy..


The other 14 patches all look ok.

Thanks,
NeilBrown
