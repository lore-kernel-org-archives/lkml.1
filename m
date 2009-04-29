Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZD2Rkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZD2Rkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbZD2Rke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:40:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbZD2Rke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:40:34 -0400
Message-ID: <49F890D0.7000109@zytor.com>
Date: Wed, 29 Apr 2009 10:39:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/21] x86: add methods for writing of an MSR on several
 CPUs
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-2-git-send-email-borislav.petkov@amd.com>
In-Reply-To: <1241024107-14535-2-git-send-email-borislav.petkov@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> +}
> +
> +/* rdmsr on a bunch of cpus
> + *
> + * @mask:	which cpus
> + * @msr_no:	which MSR
> + * @l:		array of the lower 32-bit MSR values
> + * @h:		array of the higher 32-bit MSR values
> + *

Urk!

Please, for the love of God, no!

Make it an array of u64s or (equivalently!) an array of (l,h)
structures, not separate arrays for the halves of the register.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

