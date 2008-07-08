Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbYGHSEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbYGHSEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 14:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbYGHSE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 14:04:29 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:3912 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752230AbYGHSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 14:04:28 -0400
Subject: Re: [patch 2/17] Add a WARN() macro that acts like WARN_ON()+printk
From: Joe Perches <joe@perches.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20080708094023.260a31bb@infradead.org>
References: <20080708093800.274504ba@infradead.org>
	 <20080708094023.260a31bb@infradead.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 11:00:05 -0700
Message-Id: <1215540006.5553.187.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.3mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 09:40 -0700, Arjan van de Ven wrote:
> +#ifndef WARN
> +#define WARN(condition, format...) ({					\
> +	int __ret_warn_on = !!(condition);				\
> +	if (unlikely(__ret_warn_on))					\
> +		__WARN_printf(format);					\
> +	unlikely(__ret_warn_on);					\
> +})
> +#endif
> +

If all current uses of WARN are going to change, perhaps
adding an argument for KERN_<level> or removing the
KERN_<level> prefixes and standardizing on a single
KERN_<level> (KERN_WARNING?) is appropriate.

If not standardizing on a single KERN_<level> prefix,
perhaps change the conditional and using something like:

	assert_<level>(cond, fmt, arg...)
or
	assert_msg(cond, level, fmt, arg...)


