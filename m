Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXI1AJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXI1AJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 20:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbXI1AJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 20:09:09 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:58435 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbXI1AJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 20:09:08 -0400
Date: Fri, 28 Sep 2007 09:08:47 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mark Gross <mgross@linux.intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch update.
Message-ID: <20070928000847.GA30814@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mark Gross <mgross@linux.intel.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-pm <linux-pm@lists.linux-foundation.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070927022440.GB25873@linux-sh.org> <20070926210515.6725e745.randy.dunlap@oracle.com> <20070927201739.GA2831@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927201739.GA2831@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 01:17:39PM -0700, Mark Gross wrote:
> Updated qos PM parameter patch:
> Note: the replacing of latency.c with this is a separate patch.
> 
> this patch attempts to address the issues raised so far.
> 
[snip]

> +static int register_new_qos_misc(struct qos_object *qos)
> +{
> +	int ret;
> +
> +	qos->qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
> +	qos->qos_power_miscdev.name = qos->name;
> +	qos->qos_power_miscdev.fops = &qos_power_fops;
> +
> +	ret = misc_register(&qos->qos_power_miscdev);
> +
> +	return ret;
> +}
> +
Minor nit, ret is a pointless variable here, you can just return
misc_register directly.

Other than that, this looks much better!
