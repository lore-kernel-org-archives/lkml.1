Return-Path: <linux-kernel-owner+w=401wt.eu-S1751615AbXCZLyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbXCZLyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbXCZLyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:54:11 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:38734 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbXCZLyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:54:10 -0400
Date: Mon, 26 Mar 2007 20:28:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Blackfin arch: cleanup cache header file
Message-ID: <20070326112818.GA18673@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <1174903902.32691.64.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174903902.32691.64.camel@roc-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 06:11:42PM +0800, Wu, Bryan wrote:
> +#define L1_CACHE_SHIFT	5
> +#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
>  
> -/* For speed we do need to align these ...MaTed---*/
> -/*  But include/linux/cache.h does this for us if we DO not define ...MaTed---*/
> -#define __cacheline_aligned	/***** maybe no need this   Tony *****/
> +/*
> + * Don't make __cacheline_aligned and
> + * ____cacheline_aligned defined in include/linux/cache.h
> + */
> +#define __cacheline_aligned
>  #define ____cacheline_aligned
>  
You still don't need this. Ancient versions of gcc had problems with the
attribute, but it's not even possible to build the kernel with those
anymore. Please remove these and try again. You can simply alias
SMP_CACHE_BYTES to L1_CACHE_BYTES if you've left this in due to the
resulting build failure.

m68knommu seems to be another user that never got cleaned up, perhaps
it's a good time to kill that off too..
