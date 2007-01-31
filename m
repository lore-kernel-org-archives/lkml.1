Return-Path: <linux-kernel-owner+w=401wt.eu-S1161085AbXAaXjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085AbXAaXjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXAaXjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:39:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59050 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161085AbXAaXjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:39:53 -0500
Date: Wed, 31 Jan 2007 15:39:14 -0800
From: Andrew Morton <akpm@osdl.org>
To: Simon Arlott <e5d74fcd64729b17de1hc0yh0003aeoo@thunder.lp0.eu>
Cc: Simon Arlott <simon@arlott.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cxacru: Store all device status information and
 report it when atm_proc_read is called.
Message-Id: <20070131153914.eb693314.akpm@osdl.org>
In-Reply-To: <45BFB8F5.5010607@simon.arlott.org.uk>
References: <45BFB8F5.5010607@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 21:30:29 +0000
Simon Arlott <simon@arlott.org> wrote:

> +static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
> +	struct atm_dev *atm_dev, loff_t * pos, char *page)
> +{
> +	struct cxacru_data *instance = usbatm_instance->driver_data;
> +	u32 *cxinf = instance->cxinf_status;
> +	int left = *pos;
> +
> +	if (!left--)
> +		return sprintf(page, "# %s\n", usbatm_instance->description);
> +
> +	if (!left--) {
> +		if (cxinf[CXINF_LINE_STATUS] == 5) {
> +			return sprintf(page, "# UP %u/%u\n",
> +				cxinf[CXINF_DOWNSTREAM_RATE],
> +				cxinf[CXINF_UPSTREAM_RATE]);
> +		} else {
> +			return sprintf(page, "# DOWN\n");
> +		}
> +	}

hm, how well-tested was this proc interface?  The pread() and lseek()
behaviour might be strange.

I guess as long as it doesn't oops, hang or anything like that then it'll
be OK.  Anyone who does anything apart from a single big-fat-read from a 
procfile has a good chance of getting into trouble :(
