Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYFUGVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYFUGVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 02:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYFUGUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 02:20:54 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1799 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbYFUGUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 02:20:54 -0400
Message-ID: <485C9D9E.4020208@myri.com>
Date: Sat, 21 Jun 2008 08:20:14 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 6/7] x86: pat.c introduce function to check for conflicts
 with existing memtypes
References: <20080620195503.GB4105@alberich.amd.com> <20080620200709.GH4105@alberich.amd.com>
In-Reply-To: <20080620200709.GH4105@alberich.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
> ... to strip down loop body in reserve_memtype.
>
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  arch/x86/mm/pat.c |   96 ++++++++++++++++++----------------------------------
>  1 files changed, 33 insertions(+), 63 deletions(-)
>
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index 49dcd96..281ac64 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -178,6 +178,33 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
>  	return req_type;
>  }
>  
> +static int chk_conflict(struct memtype *new, struct memtype *entry,
> +			unsigned long *type)
>   

Looking at this, I thought it may be nice to add (and export to modules)
a function that checks whether a range of memory has some page attribute
applied, namely WC. The idea would be to help drivers call mtrr_add only
if ioremap_wc failed to setup WC. I am not sure it would work but it may
be easier than adding mtrr_add into ioremap_wc() as proposed in
http://lkml.org/lkml/2008/5/31/252

Brice

