Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYGQFzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYGQFzE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbYGQFyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:54:53 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:5423 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751941AbYGQFyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:54:53 -0400
Date: Thu, 17 Jul 2008 14:54:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix sh ptep_get_and_clear breakage
Message-ID: <20080717055434.GC12007@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080716164540.GF17329@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716164540.GF17329@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 07:45:40PM +0300, Adrian Bunk wrote:
> Commit 1ea0704e0da65b2b46f9142ff1391163aac24060
> (mm: add a ptep_modify_prot transaction abstraction)
> triggered on sh build errors like the following:
> 
> <--  snip  -->
> 
> ...
>   CC      arch/sh/mm/pg-sh4.o
> cc1: warnings being treated as errors
> include2/asm/pgtable.h:139: error: 'ptep_get_and_clear' declared inline after being called
> include2/asm/pgtable.h:139: error: previous declaration of 'ptep_get_and_clear' was here
> make[2]: *** [arch/sh/mm/pg-sh4.o] Error 1
> 
> <--  snip  -->
> 
> Since there's no good reason for marking these global functions as 
> "inline" this patch therefore removes the inline's.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Magnus already fixed this for pg-sh4, but the SH7705 implementation was
overlooked, so I applied your patch there. Thanks.
