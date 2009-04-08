Return-Path: <linux-kernel-owner+w=401wt.eu-S932104AbZDHMQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbZDHMQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761439AbZDHML4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 08:11:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43018 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760385AbZDHMLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 08:11:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e9GSkPEUGfx1R8LKRASYKibGRy6jWat6CWwQ2hxFf3NyLSx1TG2pcUJEYLs/h2X2Dy
         CDx4pEYCyqN+FBNJ/OIbFTt2LBL4x4SVrtSySHCwemZpFXsRGs/zuIkhdHo7xj43uziE
         TYaXmnXoyhw8TDxaJQe6ZoMvh3wCQaNFzIxXQ=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-47-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-48-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-49-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-50-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-51-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-52-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-53-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-54-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 14:11:51 +0200
Message-ID: <36ca99e90904080511r5f02717h6fbf7bc63b7ffcf9@mail.gmail.com>
Subject: Re: [PATCH 53/56] usb: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/usb/host/ehci-dbg.c |    2 +-
>  drivers/usb/host/ehci-mem.c |    6 ++----
>  2 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-mem.c b/drivers/usb/host/ehci-mem.c
> index 10d5291..c128491 100644
> --- a/drivers/usb/host/ehci-mem.c
> +++ b/drivers/usb/host/ehci-mem.c
> @@ -212,8 +211,7 @@ static int ehci_mem_init (struct ehci_hcd *ehci, gfp_t flags)
>        }
>
>        /* Hardware periodic table */
> -       ehci->periodic = (__le32 *)
> -               dma_alloc_coherent (ehci_to_hcd(ehci)->self.controller,
> +       ehci->periodic = dma_alloc_coherent (ehci_to_hcd(ehci)->self.controller,
Hmm, I would leave this in, because of the big endian/little endian
annotation. Else sparse (the static semantic checker) could complain.


>                        ehci->periodic_size * sizeof(__le32),
>                        &ehci->periodic_dma, 0);
>        if (ehci->periodic == NULL) {

Bert
