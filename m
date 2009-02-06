Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZBFB1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZBFB1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbZBFB1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:27:25 -0500
Received: from mga07.intel.com ([143.182.124.22]:22704 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbZBFB1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:27:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,388,1231142400"; 
   d="scan'208";a="107723340"
Date: Fri, 6 Feb 2009 09:26:57 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       L-K <linux-kernel@vger.kernel.org>
Subject: Re: generic swap()
Message-ID: <20090206012657.GA6850@localhost>
References: <1232097994.14073.4.camel@laptop> <20090116013834.539c692e.akpm@linux-foundation.org> <1232099136.14073.9.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232099136.14073.9.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 10:45:36AM +0100, Peter Zijlstra wrote:
> On Fri, 2009-01-16 at 01:38 -0800, Andrew Morton wrote:
> > On Fri, 16 Jan 2009 10:26:34 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Hi,
> > > 
> > > Where did this patch come from? -- I can't seem to find it on lkml at all..
> > 
> > That's a damn good question.  I received:
> 
> Hehe, one of the mysteries of life then :-)
> 
> > > The reason I ask it that I wonder why swap() has a return value?
> > 
> > Accident, I guess.
> > 
> > > +#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
> > 
> > You think it should use the do{}while(0) thing?
> 
> That was what I was thinking indeed. Non of the current users appear to
> make use of the (somewhat arbitrary) return value, so lets change it
> before someone gets creative ;-)
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

Good change, thank you Peter.

//Sorry I was not able to read this email because of VPN issues.

Fengguang

> ---
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 343df9e..7fa3718 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -480,7 +480,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>  /*
>   * swap - swap value of @a and @b
>   */
> -#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
> +#define swap(a, b) \
> +	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
>  
>  /**
>   * container_of - cast a member of a structure out to the containing structure
> 
