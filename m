Return-Path: <linux-kernel-owner+w=401wt.eu-S1753064AbYI3FQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbYI3FQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 01:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYI3FQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 01:16:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55638 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbYI3FQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 01:16:16 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 12/13] hrtimer: create a "timer_slack" field in the task struct
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, dwmw2@infradead.org, drepper@redhat.com,
       mingo@elte.hu, tglx@tglx.de
In-Reply-To: <20080901161423.59ebf2fc@infradead.org>
References: <20080901160343.75a89ec9@infradead.org> <20080901161423.59ebf2fc@infradead.org>
Message-Id: <20080930140930.ED5B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 30 Sep 2008 14:16:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan, 

Sorry for _really_ late responce.
I recently found this patch in linux-next.

In general, I like this patch.
However,

> +		case PR_SET_TIMERSLACK:
> +			if (arg2 <= 0)
> +				current->timer_slack_ns =
> +					current->default_timer_slack_ns;
> +			else
> +				current->timer_slack_ns = arg2;
> +			break;
>  		default:
>  			error = -EINVAL;
>  			break;

I wonder to why PR_SET_TIMERSLACK decreasing doesn't need root privilege.

example,
nice() systemcall is
  - nice increasing (pirority decreasing) doesn't need root privilege.
  - nice decreasing (priority incriasing) need root privilege.

So, I think time slack setting need similar one.
Otherwise, non-privilege user can increase power consumpsion easily by PR_SET_TIMERSLACK.

What do you think?


