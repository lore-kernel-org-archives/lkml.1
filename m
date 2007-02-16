Return-Path: <linux-kernel-owner+w=401wt.eu-S1946015AbXBPRPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946015AbXBPRPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 12:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946014AbXBPRPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 12:15:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60455 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946013AbXBPRPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 12:15:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH] CELL Oprofile SPU profiling updated patch
Date: Fri, 16 Feb 2007 18:14:26 +0100
User-Agent: KMail/1.9.5
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Carl Love <cel@us.ibm.com>
References: <1171497138.23691.8.camel@dyn9047021078.beaverton.ibm.com> <200702151537.51202.arnd@arndb.de> <45D4FBB0.7090109@us.ibm.com>
In-Reply-To: <45D4FBB0.7090109@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702161814.26855.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/Ppz1LrcA0/nkWCymQXsvc26VfX2cfdi8KoouIOb8r/zyFh6qqD02JCuS3xRKlsIJWblM6LLU4juektpjFdxoqj3yn5bwMfVPUS1AIrIDzjg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 February 2007 01:32, Maynard Johnson wrote:
> config OPROFILE_CELL
>         bool "OProfile for Cell Broadband Engine"
>         depends on OPROFILE && SPU_FS
>         default y if ((SPU_FS = y && OPROFILE = y) || (SPU_FS = m && 
> OPROFILE = m))
>         help
>           Profiling of Cell BE SPUs requires special support enabled
>           by this option.  Both SPU_FS and OPROFILE options must be
>           set 'y' or both be set 'm'.
> =============
> 
> Can anyone see a problem with any of this . . . or perhaps a suggestion 
> of a better way?

The text suggests it doesn't allow SPU_FS=y with OPROFILE=m, which I think
should be allowed. I also don't see any place in the code where you actually
use CONFIG_OPROFILE_CELL.

Ideally, you should be able to have an oprofile_spu module that can be
loaded after spufs.ko and oprofile.ko. In that case you only need

config OPROFILE_SPU
	depends on OPROFILE && SPU_FS
	default y

and it will automatically build oprofile_spu as a module if one of the two
is a module and won't build it if one of them is disabled.

	Arnd <><
