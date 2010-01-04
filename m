Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406Ab0ADLPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab0ADLPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 06:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370Ab0ADLPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 06:15:52 -0500
Received: from mail09.linbit.com ([212.69.161.110]:46779 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0ADLPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 06:15:51 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jan 2010 06:15:51 EST
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: Re: [Drbd-dev] [PATCH 2/5] drivers/block: Correct NULL test
Date: Mon, 4 Jan 2010 12:09:35 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0912272226550.20548@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912272226550.20548@ask.diku.dk>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001041209.35550.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The patch titeled "drivers/block: Correct NULL test" is in the
git://git.drbd.org/linux-2.6-drbd.git for-jens tree and will
flow upstream from there.

-Phil

Full quote:
> From: Julia Lawall <julia@diku.dk>
> 
> Test the just-allocated value for NULL rather than some other value.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,y;
> statement S;
> @@
> 
> x = \(kmalloc\|kcalloc\|kzalloc\)(...);
> (
> if ((x) == NULL) S
> 
> if (
> -   y
> +   x
>        == NULL)
>  S
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/block/drbd/drbd_receiver.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/drivers/block/drbd/drbd_receiver.c
>  b/drivers/block/drbd/drbd_receiver.c ---
>  a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -3944,7 +3944,7 @@ static int drbd_do_auth(struct drbd_conf
>  	}
> 
>  	right_response = kmalloc(resp_size, GFP_NOIO);
> -	if (response == NULL) {
> +	if (right_response == NULL) {
>  		dev_err(DEV, "kmalloc of right_response failed\n");
>  		rv = 0;
>  		goto fail;
