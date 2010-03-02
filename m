Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0CBUvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:51:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219Ab0CBUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:51:14 -0500
Date: Tue, 2 Mar 2010 12:50:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?=EC=A0=95=EC=9E=AC=ED=9B=88?= <jh80.chung@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [PATCH] rfkill bug fixed in rfkill_set_sw_state
Message-Id: <20100302125003.f7919c53.akpm@linux-foundation.org>
In-Reply-To: <000301cab69f$ec61ad00$c5250700$%chung@samsung.com>
References: <000301cab69f$ec61ad00$c5250700$%chung@samsung.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suitable cc's (from scripts/get_maintainer.pl) added.

On Fri, 26 Feb 2010 13:55:31 +0900
_________ <jh80.chung@samsung.com> wrote:

> Don___t work expected operation in __rfkill_set_sw_state. 
> when rfkill initialized. Rfkill___s blocked & unblocked is operating on the
> contrary.
> 
> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
> 
> ---
>  net/rfkill/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index c224cb2..dcc2d38 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c
> @@ -488,7 +488,7 @@ static void __rfkill_set_sw_state(struct rfkill
> *rfkill, bool blocked)
>  	if (rfkill->state & RFKILL_BLOCK_SW_SETCALL)
>  		bit = RFKILL_BLOCK_SW_PREV;
>  
> -	if (blocked)
> +	if (!blocked)
>  		rfkill->state |= bit;
>  	else
>  		rfkill->state &= ~bit;

Are you sure?  What problems were you observing with the existing code?
Please fully describe your hardware and the driver's behaviour.

The current code _looks_ OK to me.  If bool `blocked' is true, we set
the RFKILL_BLOCK_SW bit?

