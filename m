Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZINNWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZINNWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbZINNWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:22:08 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59591 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755389AbZINNWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:22:07 -0400
X-Sasl-enc: ttke4n7jj+qClG6JfZRG5M6qdUG/kERvtqK5lOoEMAKQ 1252934530
Date: Mon, 14 Sep 2009 10:22:07 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Corentin Chary <corentincj@iksaif.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Julia Lawall <julia@diku.dk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/3] thinkpad_acpi: fix rfkill memory leak on unload
Message-ID: <20090914132207.GB32253@khazad-dum.debian.net>
References: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
 <1252925033-29696-2-git-send-email-corentincj@iksaif.net>
 <1252925033-29696-3-git-send-email-corentincj@iksaif.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252925033-29696-3-git-send-email-corentincj@iksaif.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Sep 2009, Corentin Chary wrote:
> rfkill_unregister() should always be followed by rfkill_destroy()
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org

> ---
>  drivers/platform/x86/thinkpad_acpi.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index e856008..21c9715 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -1278,6 +1278,7 @@ static void tpacpi_destroy_rfkill(const enum tpacpi_rfk_id id)
>  	tp_rfk = tpacpi_rfkill_switches[id];
>  	if (tp_rfk) {
>  		rfkill_unregister(tp_rfk->rfkill);
> +		rfkill_destroy(tp_rfk->rfkill);
>  		tpacpi_rfkill_switches[id] = NULL;
>  		kfree(tp_rfk);
>  	}

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
