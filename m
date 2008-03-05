Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbYCEXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbYCEXSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbYCEXR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:17:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933778AbYCEXRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:17:24 -0500
Date: Wed, 5 Mar 2008 15:17:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: oakad@exemail.com.au
Cc: linux-kernel@vger.kernel.org, oakad@yahoo.com
Subject: Re: [PATCH 11/11] memstick: add support for JMicron jmb38x
 MemoryStick host controller
Message-Id: <20080305151702.0d19f722.akpm@linux-foundation.org>
In-Reply-To: <1204646548-27466-12-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-2-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-3-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-4-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-5-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-6-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-7-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-8-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-9-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-10-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-11-git-send-email-oakad@exemail.com.au>
	<1204646548-27466-12-git-send-email-oakad@exemail.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2008 03:02:28 +1100
oakad@exemail.com.au wrote:

> +static void jmb38x_ms_reset(struct jmb38x_ms_host *host)
> +{
> +	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
> +
> +	writel(host_ctl | HOST_CONTROL_RESET_REQ | HOST_CONTROL_RESET,
> +	       host->addr + HOST_CONTROL);
> +
> +	while (HOST_CONTROL_RESET_REQ
> +	       & (host_ctl = readl(host->addr + HOST_CONTROL))) {

host_ctl is written to but is not used again.

> +		ndelay(100);
> +		dev_dbg(&host->chip->pdev->dev, "reset\n");
> +	}
> +
> +	writel(INT_STATUS_ALL, host->addr + INT_STATUS_ENABLE);
> +	writel(INT_STATUS_ALL, host->addr + INT_SIGNAL_ENABLE);
> +
> +	dev_dbg(&host->chip->pdev->dev, "reset\n");
> +}
