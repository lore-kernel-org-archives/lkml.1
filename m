Return-Path: <linux-kernel-owner+w=401wt.eu-S1765241AbXJSVJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765241AbXJSVJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966919AbXJSVJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:09:32 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59343 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966732AbXJSVJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:09:30 -0400
Date: Fri, 19 Oct 2007 14:09:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] drivers-edac-add Cell MC driver
Message-Id: <20071019140918.bedc6be5.akpm@linux-foundation.org>
In-Reply-To: <471902d7.hBdUrev76DdB/GOb%dougthompson@xmission.com>
References: <471902d7.hBdUrev76DdB/GOb%dougthompson@xmission.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 13:17:43 -0600
dougthompson@xmission.com wrote:

> +	/* The procedure for clearing FIR bits is a bit ... weird */
> +	if (clear) {
> +		fir &= ~(CBE_MIC_FIR_ECC_ERR_MASK | CBE_MIC_FIR_ECC_SET_MASK);
> +		fir |= CBE_MIC_FIR_ECC_RESET_MASK;
> +		fir &= ~clear;
> +		out_be64(&priv->regs->mic_fir, fir);
> +		(void)in_be64(&priv->regs->mic_fir);

The (void) cast isn't particularly popular practice.  Did you find that it
actually does anything useful?

> +
> +		mb();	/* sync up */

What's this here for?  It could do with a more usful comment.

If it's trying to perform some synchronisation of device register access
then I suspect it didn't work.  Or maybe it happens to work because of how
ppc implements mb(), in which case a direct use of the appropriate ppc
primitive might be clearer.

> +#ifdef DEBUG
> +		fir = in_be64(&priv->regs->mic_fir);
> +		dev_dbg(mci->dev, "fir clear  : 0x%016lx\n", fir);
> +#endif
> +	}
