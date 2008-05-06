Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbYEFLgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbYEFLgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 07:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYEFLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 07:36:14 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58340 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYEFLgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 07:36:12 -0400
Date: Tue, 6 May 2008 14:35:00 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] x86: e820 unification: Extract common functions
Message-ID: <20080506113500.GB2359@cs181133002.pp.htv.fi>
References: <20080505190213.714827651@sgi.com> <20080505190247.676948211@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080505190247.676948211@sgi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 12:02:17PM -0700, Christoph Lameter wrote:
> Extract the common functions to the common area. The parameters of
> e820_any_mapped vary between 32 and 64 bit. Convert them to unsigned long
> for 32 bit so that they match.
>...
> --- linux-2.6.orig/arch/x86/kernel/e820_32.c	2008-04-23 12:07:32.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/e820_32.c	2008-05-05 12:00:01.000000000 -0700
> @@ -645,7 +645,7 @@ void __init limit_regions(unsigned long 
>   * with type.
>   */
>  int
> -e820_any_mapped(u64 start, u64 end, unsigned type)
> +e820_any_mapped(unsigned long start,unsigned long end, unsigned type)
>  {
>  	int i;
>  	for (i = 0; i < e820.nr_map; i++) {

This changes the parameters from 64bit to 32bit which looks fishy.

Are you sure the solution that would both match and be correct isn't to 
change the 64bit one to u64?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

