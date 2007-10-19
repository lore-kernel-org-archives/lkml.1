Return-Path: <linux-kernel-owner+w=401wt.eu-S967017AbXJSVLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967017AbXJSVLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932355AbXJSVL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:11:27 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54179 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765301AbXJSVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:11:26 -0400
Date: Fri, 19 Oct 2007 14:11:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] drivers-edac-i3000 replace macros with functions
Message-Id: <20071019141118.91846dee.akpm@linux-foundation.org>
In-Reply-To: <471902ff.FaxIbGYEsl+dBZCd%dougthompson@xmission.com>
References: <471902ff.FaxIbGYEsl+dBZCd%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 13:18:23 -0600
dougthompson@xmission.com wrote:

> +static inline unsigned long deap_pfn(u8 edeap, u32 deap)
> +{
> +	deap >>= PAGE_SHIFT;
> +	deap |= (edeap & 1) << (32 - PAGE_SHIFT);
> +	return deap;
> +}
> +
> +static inline unsigned long deap_offset(u32 deap)
> +{
> +	return deap & ~(I3000_DEAP_GRAIN - 1) & ~PAGE_MASK;
> +}
> +

The types here look a bit confused.  Implicit conversions of
u32s into unsigned longs.
