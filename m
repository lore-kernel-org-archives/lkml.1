Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXB0U1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXB0U1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXB0U1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:27:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbXB0U1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:27:09 -0500
Date: Tue, 27 Feb 2007 12:26:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Arlott <6bb2a87f9b7b4e2eab1hkmdb0005e80d@thunder.lp0.eu>
Cc: simon@arlott.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cxacru: Export detailed device info through sysfs.
 (updated, card_info array one element too large)
Message-Id: <20070227122621.fde461ae.akpm@linux-foundation.org>
In-Reply-To: <45DF9C3F.1040309@simon.arlott.org.uk>
References: <45DF6AB3.4010705@simon.arlott.org.uk>
	<45DF9C3F.1040309@simon.arlott.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 24 Feb 2007 02:00:31 +0000 Simon Arlott <simon@arlott.org> wrote:
> When the device is polled for status there is a lot of useful status
> information available that is ignored. This patch stores the device
> info array when the status is polled and adds sysfs files to the usb
> device to allow userspace to query it. Since the device updates its
> status internally once a second the poll time is changed to this, and
> round_jiffies_relative is used to avoid waking the cpu unnecessarily.
> 
> ..
>
> +static ssize_t cxacru_sysfs_showattr_bool(u32 value, char *buf)
> +{
> +	switch (value) {
> +	case 0: return snprintf(buf, PAGE_SIZE, "no\n");
> +	case 1: return snprintf(buf, PAGE_SIZE, "yes\n");
> +	default: return 0;
> +	}
> +}
> +
> +static ssize_t cxacru_sysfs_showattr_LINK(u32 value, char *buf)
> +{
> +	switch (value) {
> +	case 1: return snprintf(buf, PAGE_SIZE, "not connected\n");
> +	case 2: return snprintf(buf, PAGE_SIZE, "connected\n");
> +	case 3: return snprintf(buf, PAGE_SIZE, "lost\n");
> +	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
> +	}
> +}
> +
> +static ssize_t cxacru_sysfs_showattr_LINE(u32 value, char *buf)
> +{
> +	switch (value) {
> +	case 0: return snprintf(buf, PAGE_SIZE, "down\n");
> +	case 1: return snprintf(buf, PAGE_SIZE, "attempting to activate\n");
> +	case 2: return snprintf(buf, PAGE_SIZE, "training\n");
> +	case 3: return snprintf(buf, PAGE_SIZE, "channel analysis\n");
> +	case 4: return snprintf(buf, PAGE_SIZE, "exchange\n");
> +	case 5: return snprintf(buf, PAGE_SIZE, "up\n");
> +	case 6: return snprintf(buf, PAGE_SIZE, "waiting\n");
> +	case 7: return snprintf(buf, PAGE_SIZE, "initialising\n");
> +	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
> +	}
> +}
> +
> +static ssize_t cxacru_sysfs_showattr_MODU(u32 value, char *buf)
> +{
> +	switch (value) {
> +	case 0: return 0;
> +	case 1: return snprintf(buf, PAGE_SIZE, "ANSI T1.413\n");
> +	case 2: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.1 (G.DMT)\n");
> +	case 3: return snprintf(buf, PAGE_SIZE, "ITU-T G.992.2 (G.LITE)\n");
> +	default: return snprintf(buf, PAGE_SIZE, "unknown (%u)\n", value);
> +	}
> +}

It is conventional to do

	switch (a) {
	case 0:
		stuff();
		break;
	case 1:
		stuff();
	}

But all the above could be array-driven anyway.


