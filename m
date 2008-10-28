Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYJ1VJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYJ1VJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJ1VIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:08:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:59694 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYJ1VIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Q9D/yhjO5Ko6Y2fWUVvi6VKl1++jgeX0pT5l0s1rYGsGtCL68ADT6QbaFlAwBhaP84
         rPruHVp4nxv6xcSphmCwqpMbJ8cdAGblTo8zcTiVDX3AeG185RDhTy4RGQZiY4xlwblk
         MDgWl45ZEW0SP7cgpmOZ+B2g/hnXM21GNh/6g=
Message-ID: <84144f020810281408g4adda06em5cd7a620bf837b53@mail.gmail.com>
Date: Tue, 28 Oct 2008 23:08:50 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH 2/2] w35und: plug memory leak in wbsoft_tx()
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081028193204.GI16452@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0810280014140.9821@melkki.cs.Helsinki.FI>
	 <20081028193204.GI16452@elf.ucw.cz>
X-Google-Sender-Auth: 8d800e570903177c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-28 00:14:38, Pekka J Enberg wrote:
>> From: Pekka Enberg <penberg@cs.helsinki.fi>
>>
>> There's no reason to duplicate the skb in wbsoft_tx() and leak GFP_ATOMIC
>> memory as the contents are copied to ->TxBuffer in MdxTx() anyway before
>> MLMESendFrame() returns.

On Tue, Oct 28, 2008 at 9:32 PM, Pavel Machek <pavel@suse.cz> wrote:
> Acked-by: Pavel Machek <pavel@suse.cz>
>
> ...but I guess I should test the this after it hits the mainline...

For sure. I'm bit surprised no one noticed this before as it seems to
be leaking memory for every transmitted frame...
