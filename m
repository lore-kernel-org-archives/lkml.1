Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZKUE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZKUE5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 23:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZKUE5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 23:57:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54779 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbZKUE5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 23:57:12 -0500
X-Sasl-enc: co5B+PH/XXLY8mtxXfYR3zubgsssmEeJb8iJ8TQavq4T 1258779437
Date: Sat, 21 Nov 2009 02:57:13 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] thinkpad-acpi: should error return be nagative?
Message-ID: <20091121045713.GA30424@khazad-dum.debian.net>
References: <4B06E477.3000503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B06E477.3000503@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009, Roel Kluin wrote:
> The returned error should be negative
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Is this maybe required?

Yes, it is.  Thank you for noticing this.

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org

I will queue it, and send it in during the merge window, and also to -stable
so that it can go into 2.6.31.y and 2.6.32.y.

Andrew, if you'd rather send it to Linus right now since it is an obvious
one-char fix, well, I'd not oppose it at all :-)

> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index d93108d..03c0a56 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -6313,7 +6313,7 @@ static int brightness_write(char *buf)
>  	 * Doing it this way makes the syscall restartable in case of EINTR
>  	 */
>  	rc = brightness_set(level);
> -	return (rc == -EINTR)? ERESTARTSYS : rc;
> +	return (rc == -EINTR)? -ERESTARTSYS : rc;
>  }
>  
>  static struct ibm_struct brightness_driver_data = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
