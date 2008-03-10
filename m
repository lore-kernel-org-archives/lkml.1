Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYCJVYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYCJVYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYCJVY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:24:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619AbYCJVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:24:27 -0400
Date: Mon, 10 Mar 2008 14:24:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/6] gxfb: create DC/VP/FP-specific handlers rather than
 using readl/writel
Message-Id: <20080310142405.e8b92156.akpm@linux-foundation.org>
In-Reply-To: <20080308204826.0d399caf@ephemeral>
References: <20080308204826.0d399caf@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Mar 2008 20:48:26 -0500
Andres Salomon <dilinger@queued.net> wrote:

> +#define read_dc(reg)		readl(par->dc_regs + (reg))
> +#define write_dc(reg, val)	writel((val), par->dc_regs + (reg))
> +
> +#define read_vp(reg)		readl(par->vid_regs + (reg))
> +#define write_vp(reg, val)	writel((uint32_t) (val), \
> +					par->vid_regs + (reg))
> +
> +#define read_fp(reg)		readl(par->vid_regs + (reg))
> +#define write_fp(reg, val)	writel((uint32_t) (val), \
> +					par->vid_regs + (reg))
> +

Not very nice, sorry.  They're macros, and macros rather suck.  And they
implicitly rely upon the caller having some variable called "par" in scope.

It would be much nicer to do

/*
 * documentation goes here
 */
static inline u32 read_dc(struct geodefb_par *par, int reg)
{
	return readl(par->dc_regs, reg);
}

no?
