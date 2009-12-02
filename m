Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbZLBXRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbZLBXRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZLBXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:17:09 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:42613 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZLBXRI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:17:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jwNkWAgoxr/Bf8jOzORXXxyWH4LWv3rDSDyAORjvjsuLZ2doOhVGU5OQpFVoxOrEBt
         bWF14H1u22xUi1SWu+FHT5qdSKX07swdXesXHZyDDZfxhMjoGut8zQFCBeflZ64pctrE
         E5mS3B3UeudPLXVcHmgvkQybn04skZoj7njrk=
MIME-Version: 1.0
In-Reply-To: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com>
References: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 2 Dec 2009 15:16:54 -0800
Message-ID: <43e72e890912021516k736db118j217dc92496db8f19@mail.gmail.com>
Subject: Re: [ath9k-devel] BUG kmalloc-8192: Poison overwritten
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 2:27 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> I have no idea what this is:
> (first time I've seen this);
>
>
> [   13.055592] =============================================================================
> [   13.055865] BUG kmalloc-8192: Poison overwritten
> [   13.056046] -----------------------------------------------------------------------------

I believe this means we write to an area in memory after we freed an skb.

> [   13.056366] INFO: 0xffff88003290a100-0xffff88003290a143. First byte
> 0x50 instead of 0x6b
> [   13.056366] INFO: Allocated in ath_rxbuf_alloc+0x25/0x94 [ath]
> age=8898 cpu=0 pid=892
> [   13.056366] INFO: Freed in skb_release_data+0xc1/0xc6 age=99 cpu=0 pid=0
> [   13.056366] INFO: Slab 0xffffea0000b0f9c0 objects=3 used=0
> fp=0xffff88003290c090 flags=0x4000000000004082
> [   13.056366] INFO: Object 0xffff88003290a048 @offset=8264
> fp=0xffff880032908000
> [   13.056366]
> [   13.056366] Bytes b4 0xffff88003290a038:  b9 9e fb ff 00 00 00 00
> 5a 5a 5a 5a 5a 5a 5a 5a ¹.ûÿ....ZZZZZZZZ

Can you reproduce this? We had a similar report from Miles Lanes I
have been trying to followup on for a while now. The suggested patches
to try are:

http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/70-mac80211-total-ampdu-tx-info.patch
http://bombadil.infradead.org/~mcgrof/patches/ath9k/2009/11-19/71-ath9k-remove-tx_info_priv.patch

  Luis
