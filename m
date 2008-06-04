Return-Path: <linux-kernel-owner+w=401wt.eu-S1759129AbYFDI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129AbYFDI4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 04:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYFDI4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 04:56:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49454 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYFDI4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 04:56:39 -0400
Subject: Re: [PATCH] add a printk_init variant storing format strings in
	__initdata
From: David Woodhouse <dwmw2@infradead.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, pavel@suse.cz,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       mingo@elte.hu
In-Reply-To: <1212485252.0@pinky>
References: <20080529162257.03426e48.akpm@linux-foundation.org>
	 <1212485252.0@pinky>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 09:56:32 +0100
Message-Id: <1212569792.4042.52.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 10:27 +0100, Andy Whitcroft wrote:
> +#define printk_init(fmt, args...) \
> +do { \
> +        static char __printk_init_fmt[] __initdata = fmt; \
> +        __printk_init(__printk_init_fmt, ##args); \
> +} while (0)

Hm, do these strings still get merged? Perhaps we want them in
a .initdata.str section on their own?

Bonus points for letting the linker 'merge' such strings into the
real .rodata.str section if they exist there too.

-- 
dwmw2

