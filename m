Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYCQPlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYCQPlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 11:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751834AbYCQPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 11:40:59 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:57261 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYCQPk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 11:40:58 -0400
Date: Mon, 17 Mar 2008 11:40:57 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "S.?a??lar Onur" <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-parisc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] arch/parisc/kernel/unaligned.c: Use time_* macros
Message-ID: <20080317154057.GD3904@phobos.i.cabal.ca>
References: <1205746593-24820-1-git-send-email-caglar@pardus.org.tr> <1205746593-24820-2-git-send-email-caglar@pardus.org.tr> <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 17, 2008 at 11:36:25AM +0200, S.?a??lar Onur wrote:

Sorry, I seem to be losing at charsets with your name. :(

> The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.
> 
> So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly
> 

I prefer the idea of using printk_ratelimit. I've committed a patch that
does this to git and credited you with pointing it out.

cheers, Kyle

> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: linux-parisc@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: S.Ça??lar Onur <caglar@pardus.org.tr>
> ---
>  arch/parisc/kernel/unaligned.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
> index aebf3c1..19b8a79 100644
> --- a/arch/parisc/kernel/unaligned.c
> +++ b/arch/parisc/kernel/unaligned.c
> @@ -460,7 +460,7 @@ void handle_unaligned(struct pt_regs *regs)
>  			goto force_sigbus;
>  		}
>  
> -		if (unaligned_count > 5 && jiffies - last_time > 5*HZ) {
> +		if (unaligned_count > 5 && time_after(jiffies, last_time + 5 * HZ)) {
>  			unaligned_count = 0;
>  			last_time = jiffies;
>  		}
> -- 
> 1.5.4.3
> 
