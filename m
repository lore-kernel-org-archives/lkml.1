Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYBOWAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYBOWAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757763AbYBOWAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:00:38 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:46368 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708AbYBOWAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:00:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SIGS9JcEjZAERf0gMaHAEsXbowHR7QY2z3e0LIqXRzXRUmV9vb+c9M/npz63jIfvBxXXeRBi6FwgMIAF0qPQfZ+vQbyVgfcHzavwkjz1nlkjEcQn20X3gO6jzJbg5DVr3qPfW+h8bzsYNt8mheZp5zmKzQsM+y9ulbGbxkr7goU=
Message-ID: <40f31dec0802151400r7423c8e9w2524cba76618e07e@mail.gmail.com>
Date: Sat, 16 Feb 2008 00:00:34 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/3] WDEV: ath5k, fix lock imbalance
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/2/15, Jiri Slaby <jirislaby@gmail.com>:
> Omitted lock causes sparse warning
>  drivers/net/wireless/ath5k/base.c:1682:1: warning: context imbalance in 'ath5k_tasklet_rx' - different lock contexts for basic block
>
>  Add the lock to the guilty fail path.
>
>  Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>  Cc: Nick Kossifidis <mickflemm@gmail.com>
>  Cc: Luis R. Rodriguez <mcgrof@gmail.com>
>  ---
>   drivers/net/wireless/ath5k/base.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
>  diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
>  index ddc8714..49d38e8 100644
>  --- a/drivers/net/wireless/ath5k/base.c
>  +++ b/drivers/net/wireless/ath5k/base.c
>  @@ -1715,6 +1715,7 @@ ath5k_tasklet_rx(unsigned long data)
>                         break;
>                 else if (unlikely(ret)) {
>                         ATH5K_ERR(sc, "error in processing rx descriptor\n");
>  +                       spin_unlock(&sc->rxbuflock);
>                         return;
>                 }
>
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
