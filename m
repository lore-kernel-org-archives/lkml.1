Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYF0RM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYF0RM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbYF0RMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:12:19 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:41794 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbYF0RMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:12:18 -0400
Date: Fri, 27 Jun 2008 12:26:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix extern inline errors with gcc 4.3.0
Message-ID: <20080627162645.GC8381@c2.user-mode-linux.org>
References: <1214488251-20927-1-git-send-email-bhalevy@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214488251-20927-1-git-send-email-bhalevy@panasas.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 04:50:51PM +0300, Benny Halevy wrote:
> -KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
> +# Disable unit-at-a-time mode on pre-gcc-4.3 compilers, it makes gcc use
> +# a lot more stack due to the lack of sharing of stacklots:
> +# gcc 4.3.0 needs -funit-at-a-time for extern inline functions
> +KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0403 ] ; then \
> +			echo $(call cc-option,-fno-unit-at-a-time); fi ;)

How do we know that this patch won't cause the same crash reported in
http://marc.info/?l=linux-kernel&m=121011722806093&w=2?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
