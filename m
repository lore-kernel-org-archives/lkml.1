Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXKIIiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXKIIiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 03:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbXKIIiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 03:38:13 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbXKIIiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 03:38:12 -0500
Message-ID: <47341C4A.30508@redhat.com>
Date: Fri, 09 Nov 2007 09:37:30 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, avi@qumranet.com,
       aliguori@us.ibm.com, kvm-devel@lists.sourceforge.net,
       hollisb@us.ibm.com
Subject: Re: [PATCH 1/3] include files for kvmclock
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com>
In-Reply-To: <11945615703593-git-send-email-gcosta@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Guest has page alignment and padding requirements. At the host, it will
> + * only lead to wasted space at the vcpu struct. For this reason, the struct
> + * is not anonymous
> + */
> +union kvm_hv_clock {
> +	struct kvm_hv_clock_s {
> +		u64 tsc_mult;
> +		u64 now_ns;
> +		/* That's the wall clock, not the water closet */
> +		u64 wc_sec;
> +		u64 last_tsc;
> +		/* At first, we could use the tsc value as a marker, but Jeremy
> +		 * well noted that it will cause us locking problems in 32-bit
> +		 * sys, so we have a special version field */
> +		u32 version;
> +	} fields;
> +	char page_align[PAGE_SIZE];
> +};

What is the point in using a whole page per vcpu?  You probably don't
want struct kvm_hv_clock_s cross a page border.  Is that the only reason
or are there other constrains too?

As the kvm clock looks quite simliar to what xen does, how about making
the structs binary-compatible or simply reuse the xen version (struct
vcpu_time_info in xen/interface/xen.h)?

cheers,
  Gerd
