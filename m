Return-Path: <linux-kernel-owner+w=401wt.eu-S1760144AbYGPQMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760144AbYGPQMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759267AbYGPQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:12:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:47082 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791AbYGPQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:12:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wYotf7DyrE/ERWaDFzf0YAydfZrP+2He+3P9q8BzWWlC9/4E/aIHXKDQ6Z2p3GZYWw
         CxmDMIxXS/U197B6wEc02uc8sIgDZ9C9kbUe3RCm4A91kHdHrdWC4ja5Ccx2NrMF/V1g
         IMI9XVGDLAKby/yrDEdPQgxzsIVQiuH1Elf9w=
Message-ID: <40f31dec0807160912t54316c26nedfff2d756f16b5a@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:12:21 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/5] Ath5k: kill tasklets on shutdown
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1216136661-10930-2-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <1216136661-10930-2-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Jiri Slaby <jirislaby@gmail.com>:
> Don't forget to kill tasklets on stop to not panic if they
> fire after freeing some structures.
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index e9ec284..4d9ff97 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2343,6 +2343,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>        mutex_unlock(&sc->lock);
>
>        del_timer_sync(&sc->calib_tim);
> +       tasklet_kill(&sc->rxtq);
> +       tasklet_kill(&sc->txtq);
> +       tasklet_kill(&sc->restq);
>
>        return ret;
>  }
> --
> 1.5.6.2
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
