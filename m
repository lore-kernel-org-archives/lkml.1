Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYKXOms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYKXOms (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 09:42:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYKXOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 09:42:41 -0500
Received: from smtp-out-41.synserver.de ([217.119.50.41]:1062 "HELO
	smtp-out-41.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752563AbYKXOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 09:42:40 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 10165
Date: Mon, 24 Nov 2008 15:42:36 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc6-tip fails to build with gcc 4.4.0
Message-ID: <20081124144236.GA2318@gentoox2.trippelsdorf.de>
References: <492AB9FD.5010602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492AB9FD.5010602@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 04:28:13PM +0200, Török Edwin wrote:
> Hi,
> 
> Using gcc version 4.4.0 20081120 (experimental) [trunk revision 142055]
> I can't build latest tip/master (commit
> b27fef5b222564b6e7ae71f7110c233b2fb45a38)
> 
> drivers/built-in.o: In function `sd_revalidate_disk':
> sd.c:(.text+0x8bc76): undefined reference to `____ilog2_NaN'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Apparently gcc determines that sector_size can have an invalid constant
> value as ilog2's parameter in sd_read_capacity.

> Did it find a real bug in sd.c, or is it a gcc bug?

See: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=36359

Setting CONFIG_CC_OPTIMIZE_FOR_SIZE=y in your .config should fix it for
now.

-- 
Markus
