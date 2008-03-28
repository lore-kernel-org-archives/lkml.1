Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYC1CHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYC1CHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbYC1CH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:07:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:20319 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYC1CH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:07:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,566,1199692800"; 
   d="scan'208";a="541358140"
Subject: Re: [PATCH -mm 2/4] x86_64 boot: Add linked list of struct
	setup_data
From: "Huang, Ying" <ying.huang@intel.com>
To: Paul Jackson <pj@sgi.com>
Cc: hpa@zytor.com, andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080327062539.5cbcb925.pj@sgi.com>
References: <1206601748.3067.22.camel@caritas-dev.intel.com>
	 <20080327062539.5cbcb925.pj@sgi.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Mar 2008 10:08:37 +0800
Message-Id: <1206670117.13404.6.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 28 Mar 2008 02:05:33.0967 (UTC) FILETIME=[34FF21F0:01C89078]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 06:25 -0500, Paul Jackson wrote:
> Huang wrote:
> +	while (pa_data) {
> +		data = early_ioremap(pa_data, PAGE_SIZE);
> +		switch (data->type) {
> +		default:
> +			break;
> +		}
> 
> Isn't that switch statement equivalent to -always- breaking, as in:
> 
> +	while (pa_data) {
> +		data = early_ioremap(pa_data, PAGE_SIZE);
> +		break;
> 
> I doubt you want to do that.  I suppose what you want to do is check for
> data == NULL instead, as in:
> 
> +	while (pa_data) {
> +		data = early_ioremap(pa_data, PAGE_SIZE);
> +		if (!data)
> +			break;

This break will break the switch instead of while. When setup_data
processing code is added, the code will looks like:

#define SETUP_DATA_E820_EXT	1

while (pa_data) {
	data = early_ioremap(pa_data, PAGE_SIZE);
	switch (data->type) {
	case SETUP_DATA_E820_EXT:
		parse_e820_ext(data, pa_data);
		break;
	default:
		break;
	}
...

Best Regards,
Huang Ying
