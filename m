Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXDVXwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXDVXwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 19:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161187AbXDVXwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 19:52:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:45270 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbXDVXwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 19:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NzOCWKdDcZFAK09n4Bw7bXry5ULjPCYksLJmE+GdwVCRUXC8dNF1q4pRX3aO7jV9JC6k9ZPowvPoc4dSwQ0zemZ44hLeTSDzLXXPkjWqvXdn0Uu8A14kmoW/t5yvfLQLBE7qn+uOFwJ6Mou6iuxKvj45yAZnhmal+muoi60fOAY=
Message-ID: <a781481a0704221652h51a73c21t4ae5ff66760ccee3@mail.gmail.com>
Date: Mon, 23 Apr 2007 05:22:10 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, chas@cmf.nrl.navy.mil,
       ecd@atecom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use spinlock instead of binary mutex in idt77252 driver
In-Reply-To: <20070422213959.GP5013@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070422213959.GP5013@traven>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/23/07, Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:
> use spinlock instead of binary mutex in idt77252 driver
>
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
>
> --
>
> diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
> index b4b8014..e3cf141 100644
> --- a/drivers/atm/idt77252.c
> +++ b/drivers/atm/idt77252.c
> @@ -2430,7 +2430,7 @@ idt77252_open(struct atm_vcc *vcc)
>
>         set_bit(ATM_VF_ADDR, &vcc->flags);
>
> -       down(&card->mutex);
> +       mutex_lock(&card->mutex);

Note that you're actually replacing a semaphore with a mutex here (and
not a mutex with a spinlock). I guess that should be fine and
desirable as long as the semaphore was indeed being used a mutex
(binary) in this code.
