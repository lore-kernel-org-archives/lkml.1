Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbYK0May@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbYK0May (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbYK0Maq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:30:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45946 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYK0Map (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:30:45 -0500
Date: Thu, 27 Nov 2008 13:41:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: eranian@gmail.com
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, x86@kernel.org,
       andi@firstfloor.org, sfr@canb.auug.org.au,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 20/24] perfmon: system calls interface
Message-ID: <20081127124116.GK6703@one.firstfloor.org>
References: <492d0c0b.170e660a.15ba.ffffdabf@mx.google.com> <20081126140027.GC6562@elte.hu> <20081126165948.GA15755@redhat.com> <7c86c4470811270425i435a2adcq565d674070fd44db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470811270425i435a2adcq565d674070fd44db@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  int pfm_create(int flags, pfarg_sinfo_t *sif, char *fmt_name, void
> *fmt_arg, size_t arg_sz);
> 
> The kernel would look at the last 3 arguments ONLY if it saw the
> PFM_FL_SMPL_FMT bit
>  set in flags. We follow the model used by open(2).

Normally it's a better model to enforce 0 (or whatever appropiate)
in unused argument. That can be done by checking and returning EINVAL.

> 
> I want to double-check that you are fine with this approach.

My recommendation would be to go with the full format 
from the beginning, because otherwise there is a versioning problem 
with glibc.


-Andi

-- 
ak@linux.intel.com
