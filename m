Return-Path: <linux-kernel-owner+w=401wt.eu-S1759583AbYFLB1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759583AbYFLB1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbYFLB1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:27:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755326AbYFLB1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:27:38 -0400
Date: Wed, 11 Jun 2008 18:27:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Bohac <jbohac@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] console keyboard mapping broken by 04c71976
Message-Id: <20080611182706.f8e2cc8c.akpm@linux-foundation.org>
In-Reply-To: <20080612011832.GM4718@implementation>
References: <20080611134837.GA11462@midget.suse.cz>
	<20080612011832.GM4718@implementation>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 02:18:32 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> 
> Ok, a closer look agrees with the patch, but no need to keep the uni
> variable then, here is an updated patch.  Thanks!
> 
> From: Jiri Bohac <jbohac@suse.cz>
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> 
> diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
> index 7f7e798..16492b7 100644
> --- a/drivers/char/keyboard.c
> +++ b/drivers/char/keyboard.c
> @@ -678,10 +678,5 @@
>  static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
>  {
> -	unsigned int uni;
> -	if (kbd->kbdmode == VC_UNICODE)
> -		uni = value;
> -	else
> -		uni = conv_8bit_to_uni(value);
> -	k_unicode(vc, uni, up_flag);
> +	k_unicode(vc, conv_8bit_to_uni(value), up_flag);
>  }

Is this ready to be applied?  If so, please send a changelog.

btw, the From: line shold be right at the top of the changelog.

Thanks.
