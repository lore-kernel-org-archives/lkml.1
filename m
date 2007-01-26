Return-Path: <linux-kernel-owner+w=401wt.eu-S1161238AbXAZTud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161238AbXAZTud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161247AbXAZTud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:50:33 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49694 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161238AbXAZTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:50:32 -0500
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 14:50:32 EST
Date: Fri, 26 Jan 2007 11:47:13 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, ocfs2-devel@oss.oracle.com
Subject: Re: [2.6 patch] fix OCFS2 compile error
Message-ID: <20070126194713.GB8176@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> <45B89008.9000809@eyal.emu.id.au> <45B965EA.20106@eyal.emu.id.au> <20070126184942.GP17836@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126184942.GP17836@stusta.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 07:49:42PM +0100, Adrian Bunk wrote:
> I don't know why gcc 3.3 generates this now since ocfs2_backup_super_blkno()
> seems to be unused, but there is a bug for 32 bit systems that should be 
> fixed:
> 
> Commit 50af94b14c98f5769860a282a397c6f3b135c8a8 adds:
>   offset /= sb->s_blocksize;
> 
> That is:
>   u64 = u64 / long
> 
> Not a problem on 64bit architectures, but obviously a problem on 32 bit 
> architectures.
> 
> This patch fixes it by using sb->s_blocksize_bits instead of sb->s_blocksize.

Thanks Adrian... I think we both hit upon this at about the same time :) My
patch made it into ocfs2.git first (for obvious reasons)...
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
