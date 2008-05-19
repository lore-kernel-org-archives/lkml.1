Return-Path: <linux-kernel-owner+w=401wt.eu-S1762418AbYESTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762418AbYESTHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761211AbYESTHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:07:40 -0400
Received: from ns.suse.de ([195.135.220.2]:43204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017AbYESTHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:07:40 -0400
Date: Mon, 19 May 2008 12:07:38 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, joel.becker@oracle.com,
       Sunil Mushran <Sunil.Mushran@oracle.com>
Subject: Re: OCFS2 printf format warnings
Message-ID: <20080519190738.GA8325@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <Pine.SOC.4.64.0805181658030.22653@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0805181658030.22653@math.ut.ee>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 04:59:26PM +0300, Meelis Roos wrote:
> Just noticed these on sparc64:
> 
>   CC [M]  fs/ocfs2/cluster/netdebug.o
> fs/ocfs2/cluster/netdebug.c: In function 'nst_seq_show':
> fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 13 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 15 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:152: warning: format '%lu' expects type 'long unsigned int', but argument 17 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c: In function 'sc_seq_show':
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 19 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 21 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 23 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 25 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 27 has type 'suseconds_t'
> fs/ocfs2/cluster/netdebug.c:332: warning: format '%lu' expects type 'long unsigned int', but argument 29 has type 'suseconds_t'


Ok, these were introduced by:

commit 2309e9e040fe29469fb85a384636c455b62fe525
Author: Sunil Mushran <sunil.mushran@oracle.com>
Date:   Mon Apr 14 10:46:19 2008 -0700

ocfs2/net: Add debug interface to o2net

...



It looks like we need some casts... Sunil, care to fix this up?
	--Mark

--
Mark Fasheh
