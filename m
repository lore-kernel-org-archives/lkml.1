Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbXGFPcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbXGFPcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760698AbXGFPcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:32:45 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:58710 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760502AbXGFPco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:32:44 -0400
Date: Fri, 6 Jul 2007 18:32:32 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Patch] Allow not mounting a root fs
Message-ID: <20070706153232.GA11907@localdomain>
References: <Pine.LNX.4.58.0707060318160.26869@be1.lrz> <468DA42D.7050309@zytor.com> <Pine.LNX.4.58.0707061551240.2241@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0707061551240.2241@be1.lrz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 05:00:40PM +0200, Bodo Eggert wrote:
> On Thu, 5 Jul 2007, H. Peter Anvin wrote:
> 
> > Bodo Eggert wrote:
> > > This patch adds the option to not mount another root filesystem 
> > > by specifying root=initramfs.
> > 
> > Uhm, the kernel doesn't mount anything if you're using an initramfs.
> 
> Yes, instead it panics trying to mount the non-existing "root=".
> I've put the complete system into initrams, and I just want the kernel to
> run /sbin/init.

If I understood you correctly, you're trying to get the kernel 
to execute the "/sbin/init" file of your initramfs. However, "/init" 
is the sole default initramfs entry point. To fix this, you can pass 
rdinit=/sbin/init _or_ modify your initramfs image so that "/init" 
is the entrypoint.

Normally, if your initramfs has a /init script your kernel would 
skip the entire stage where it panics in the perpare_namespace() 
function for trying to mount "root=" by itself (see 
init/main.c:init()).

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
