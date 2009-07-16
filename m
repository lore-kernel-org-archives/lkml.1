Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZGPJJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZGPJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZGPJJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:09:56 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:54745 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbZGPJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mFGM13GsEg8nExA5c+qjZ879Dd+gs/i8hglwc1yvS8vx/XCpB5xbOcC80TTdjIbMpu
         GoVn9LnPv+5uh9tegkGXAG6Pi/+ATfvpnjKhuGyz1FfXOhgvQZ2EYUrZED4lCDBVQdap
         Ex0CGWGZk9szQ0FoTABT9et9Hozhg8XsxlphU=
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linville@tuxdriver.com, luciano.coelho@nokia.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wireless: wl12xx, fix lock imbalance
References: <1247603833-10862-1-git-send-email-jirislaby@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Jul 2009 12:09:52 +0300
In-Reply-To: <1247603833-10862-1-git-send-email-jirislaby@gmail.com> (Jiri Slaby's message of "Tue\, 14 Jul 2009 22\:37\:13 +0200")
Message-ID: <87eish56zj.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
> wl12xx_chip_wakeup fails).

Thanks for fixing this.

> [v2]
> Power off the device, because:
> \= cite from http://marc.info/?l=linux-kernel&m=124755028209880&w=2
> If the chip cannot be booted, why should it remain powered on?
> In some rare cases, the chip might fail to initialize, but can
> recover if powered off and on again, so turning it off at this
> point is the right thing to do. =/

Yes, I agree with this.

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>  drivers/net/wireless/wl12xx/main.c |    2 +-

Unfortunately this won't apply to wireless-testing because main.c is
renamed to wl1251_main.c. Can you respin the patch or do you want me to
do it? I'm sending other wl12xx patches anyway and it's easy for me to
rebase this one at the same time.

-- 
Kalle Valo
