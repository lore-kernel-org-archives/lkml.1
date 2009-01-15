Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbZAOGQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbZAOGQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZAOGQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:16:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375AbZAOGQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:16:29 -0500
Date: Wed, 14 Jan 2009 22:16:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hunter, Jon" <jon-hunter@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [RFC] Dynamic Tick and Deferrable Timer Support
Message-Id: <20090114221624.76ee8aa4.akpm@linux-foundation.org>
In-Reply-To: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
References: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009 14:03:09 -0600 "Hunter, Jon" <jon-hunter@ti.com> wrote:

> Hello All,
> 
> I have been working to maximise the kernel sleep time on an embedded device by utilising the dynamic tick and deferrable timer features.
> 
> During the course of this work I found that although timers were configured as deferrable, only timers for time interval tv1 were actually being deferred. Reviewing the deferrable timer patch [1], it does appear that the code is written to only defer timers for interval tv1. Therefore, I wanted to ask if this is intentional or not?
> 
> I have applied the below patch to defer all deferrable timers regardless of interval and so far it is working on the embedded device. I wanted to share this in case this could be something that could be applied to the mainline.
> 
> Please excuse any foolish mistakes I may have made here as this is my first post to your mailing list. Any feedback you could offer would be appreciated.
> 
> Cheers
> Jon
> 
> [1] Deferrable timer patch: http://marc.info/?l=linux-kernel&m=117512286417320&w=2
> 
> 
> Signed-off-by: Jon Hunter <jon-hunter@ti.com>
> ---
>  kernel/timer.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/timer.c b/kernel/timer.c
> index dee3f64..76a3ac6 100644
> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -930,6 +930,9 @@ cascade:
>                 index = slot = timer_jiffies & TVN_MASK;
>                 do {
>                         list_for_each_entry(nte, varp->vec + slot, entry) {
> +                               if (tbase_get_deferrable(nte->base))
> +                                       continue;
> +
>                                 found = 1;
>                                 if (time_before(nte->expires, expires))
>                                         expires = nte->expires;

Venki, could you please take a look?
