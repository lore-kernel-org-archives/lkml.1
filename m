Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbXFASxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbXFASxS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbXFASxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:53:01 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57215 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXFASxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:53:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2.6.21 3/3] x86_64: EFI64 support
References: <20070501185945.237601000@em64tdvp.jf.intel.com>
	<20070501190111.145499000@em64tdvp.jf.intel.com>
Date: Fri, 01 Jun 2007 12:52:07 -0600
In-Reply-To: <20070501190111.145499000@em64tdvp.jf.intel.com> (Chandramouli
	Narayanan's message of "Tue, 01 May 2007 11:59:48 -0700")
Message-ID: <m1y7j3zew8.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chandramouli Narayanan <mouli@linux.intel.com> writes:

> +
> +static int __init efifb_init(void)
> +{
> +	int ret;
> +
> +	if (!efi_enabled)
> +		return -ENODEV;
> +

Please remove this efi_enabled check it appears  redundant with
the check immediately below.

> +	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
> +		return -ENODEV;
> +
> +
> +	ret = platform_driver_register(&efifb_driver);
> +
> +	if (!ret) {
> +		ret = platform_device_register(&efifb_device);
> +		if (ret)
> +			platform_driver_unregister(&efifb_driver);
> +	}
> +	return ret;
> +}
> +module_init(efifb_init);

Eric


