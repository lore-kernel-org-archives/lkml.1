Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZHCTVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZHCTVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 15:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZHCTVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 15:21:12 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:58255 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665AbZHCTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 15:21:11 -0400
From: Frans Pop <elendil@planet.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: nfs: __setup_str_nfs_root_setup causes a section type conflict
Date: Mon, 3 Aug 2009 21:21:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       parisc-linux@lists.parisc-linux.org, Helge Deller <deller@gmx.de>
References: <200907311446.33486.elendil@planet.nl> <200908020010.30459.elendil@planet.nl> <1249323782.18161.2.camel@heimdal.trondhjem.org>
In-Reply-To: <1249323782.18161.2.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908032121.10635.elendil@planet.nl>
X-OriginalArrivalTime: 03 Aug 2009 19:21:11.0455 (UTC) FILETIME=[8F7A1AF0:01CA146F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 August 2009, Trond Myklebust wrote:
> > > /home/fjp/projects/kernel/linux-2.6/fs/nfs/nfsroot.c:403:
> > >     error: __setup_str_nfs_root_setup causes a section type
> > > conflict
>
> If you do a 'make fs/nfs/nfsroot.i', and then look at the resulting
> file fs/nfs/nfsroot.i, what does the line that defines
> '__setup_str_nfs_root_setup' look like?

$ grep __setup_str_nfs_root_setup fs/nfs/nfsroot.i

static const char __setup_str_nfs_root_setup[] __attribute__ 
((__section__(".init.rodata"))) __attribute__((aligned(1))) = "nfsroot="; 
static struct obs_kernel_param __setup_nfs_root_setup 
__attribute__((__used__)) __attribute__ ((__section__(".init.setup"))) 
__attribute__((aligned((sizeof(long))))) = { __setup_str_nfs_root_setup, 
nfs_root_setup, 0 };
