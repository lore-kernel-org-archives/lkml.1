Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0CHU4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:56:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab0CHU4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:56:12 -0500
Subject: Re: [PATCH] Kernel: Fix coding style in kernel/audit.c
From: Eric Paris <eparis@redhat.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com
In-Reply-To: <20100308222742.GB17489@localhost.localdomain>
References: <20100308222742.GB17489@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 15:56:03 -0500
Message-ID: <1268081763.3227.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 06:27 +0800, wzt.wzt@gmail.com wrote:
> Fix coding style in kernel/audit.c
> 
> Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

NAK.  I think you need to figure out if() statements before you try more
coding style cleanups....

-Eric


> 
> ---
>  kernel/audit.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 5feed23..5164696 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -331,12 +331,12 @@ static int audit_set_backlog_limit(int limit, uid_t loginuid, u32 sessionid,
>  static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  {
>  	int rc;
> +
>  	if (state < AUDIT_OFF || state > AUDIT_LOCKED)
>  		return -EINVAL;
>  
>  	rc =  audit_do_config_change("audit_enabled", &audit_enabled, state,
>  				     loginuid, sessionid, sid);
> -
>  	if (!rc)
>  		audit_ever_enabled |= !!state;
>  
> @@ -346,8 +346,8 @@ static int audit_set_enabled(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  static int audit_set_failure(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  {
>  	if (state != AUDIT_FAIL_SILENT
> -	    && state != AUDIT_FAIL_PRINTK
> -	    && state != AUDIT_FAIL_PANIC)
> +		&& state != AUDIT_FAIL_PRINTK
> +		&& state != AUDIT_FAIL_PANIC)
>  		return -EINVAL;
>  
>  	return audit_do_config_change("audit_failure", &audit_failure, state,
> @@ -366,7 +366,7 @@ static int audit_set_failure(int state, uid_t loginuid, u32 sessionid, u32 sid)
>  static void audit_hold_skb(struct sk_buff *skb)
>  {
>  	if (audit_default &&
> -	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
> +		skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
>  		skb_queue_tail(&audit_skb_hold_queue, skb);
>  	else
>  		kfree_skb(skb);
> @@ -1163,9 +1163,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  				entries over the normal backlog limit */
>  
>  	while (audit_backlog_limit
> -	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
> +		&& skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
>  		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time
> -		    && time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
> +			&& time_before(jiffies, timeout_start + audit_backlog_wait_time)) {
>  
>  			/* Wait for auditd to drain the queue a little */
>  			DECLARE_WAITQUEUE(wait, current);
> @@ -1173,7 +1173,7 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  			add_wait_queue(&audit_backlog_wait, &wait);
>  
>  			if (audit_backlog_limit &&
> -			    skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
> +				skb_queue_len(&audit_skb_queue) > audit_backlog_limit)
>  				schedule_timeout(timeout_start + audit_backlog_wait_time - jiffies);
>  
>  			__set_current_state(TASK_RUNNING);
> @@ -1316,18 +1316,18 @@ void audit_log_n_hex(struct audit_buffer *ab, const unsigned char *buf,
>  	BUG_ON(!ab->skb);
>  	skb = ab->skb;
>  	avail = skb_tailroom(skb);
> -	new_len = len<<1;
> +	new_len = len << 1;
>  	if (new_len >= avail) {
>  		/* Round the buffer request up to the next multiple */
> -		new_len = AUDIT_BUFSIZ*(((new_len-avail)/AUDIT_BUFSIZ) + 1);
> +		new_len = AUDIT_BUFSIZ * (((new_len - avail) / AUDIT_BUFSIZ) + 1);
>  		avail = audit_expand(ab, new_len);
>  		if (!avail)
>  			return;
>  	}
>  
>  	ptr = skb_tail_pointer(skb);
> -	for (i=0; i<len; i++) {
> -		*ptr++ = hex[(buf[i] & 0xF0)>>4]; /* Upper nibble */
> +	for (i = 0; i < len; i++) {
> +		*ptr++ = hex[(buf[i] & 0xF0) >> 4]; /* Upper nibble */
>  		*ptr++ = hex[buf[i] & 0x0F];	  /* Lower nibble */
>  	}
>  	*ptr = 0;



