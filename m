Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZDOD17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZDOD17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZDOD1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:27:50 -0400
Received: from ozlabs.org ([203.10.76.45]:55747 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDOD1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:27:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/4] irq: make set_affinity to return status
Date: Wed, 15 Apr 2009 12:57:44 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200903231757.53709.rusty@rustcorp.com.au> <49E4F513.1060709@kernel.org> <49E4F54C.7030807@kernel.org>
In-Reply-To: <49E4F54C.7030807@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151257.44715.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 06:12:52 am Yinghai Lu wrote:
> 
> Impact: prepare to use it to keep affinity consistent
> 
> according to Ingo, change set_affinity() in irq_chip to return int.

I prefer a bool, or an actual -errno rather than -1.  Maybe Ingo feels
differently?

Plus:

> @@ -199,6 +199,8 @@ static void octeon_irq_ciu0_set_affinity
>  	 */
>  	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
>  	write_unlock(&octeon_irq_ciu0_rwlock);
> +
> +	reutrn 0;
>  }

Typo.

Thanks,
Rusty.
