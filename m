Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007Ab0AWRca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0AWRca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 12:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752Ab0AWRc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 12:32:29 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:50560 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab0AWRc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 12:32:28 -0500
Message-ID: <4B5B32AF.1010509@cox.net>
Date: Sat, 23 Jan 2010 12:32:31 -0500
From: James Kosin <james.kosin.04@cnu.edu>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: joe@perches.com
Subject: Re: [PATCH 23/24] drivers/block/floppy.c: Add function is_ready_state
References: <e5jMK-25X-3@gated-at.bofh.it> <e5jMM-25X-51@gated-at.bofh.it>
In-Reply-To: <e5jMM-25X-51@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/2010 12:00 AM, Joe Perches wrote:
> Used a couple of times, might simplify the code a bit.
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   drivers/block/floppy.c |   19 +++++++++++++++----
>   1 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 2f6ed78..fd56b26 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -782,6 +782,12 @@ static inline int is_selected(int dor, int unit)
>   	return ((dor&  (0x10<<  unit))&&  (dor&  3) == unit);
>   }
>
> +static bool is_ready_state(int status)
> +{
> +	int state = status&  (STATUS_READY | STATUS_DIR | STATUS_DMA);
> +	return state == STATUS_READY;
> +}
> +

This should probably be simplified to:

static bool is_ready_state(int status)
{
	return ((state & STATUS_READY) == STATUS_READY);
}

James
