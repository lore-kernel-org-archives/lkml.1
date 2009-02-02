Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbZBBOQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbZBBOQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBBOPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:15:55 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:47864 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbZBBOPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:15:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DdmHShviNfrJyY0acZbO3IIIqylwzd7qIbM/WrVMKR+YXAirA0yx2nkFju0kfJSuUz
         3hCsNXcFGFFydQBXNegGbwb5/hK/6wJOOTRu74r7VZgf5242M9+IT8nhFEb7a/awtnIV
         Pnpmy7mzAVIEVq62V3y3NU3dTSALFIz+Z6vEI=
MIME-Version: 1.0
In-Reply-To: <1223294503.11272.158.camel@violet.holtmann.net>
References: <1223293223-21162-1-git-send-email-tomas.winkler@intel.com>
	 <1223294503.11272.158.camel@violet.holtmann.net>
Date: Mon, 2 Feb 2009 16:15:51 +0200
Message-ID: <1ba2fa240902020615w239753a5v6973e77ed59128c9@mail.gmail.com>
Subject: Re: [PATCH V2] btsdio: fix tx error path
From: Tomas Winkler <tomasw@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2008 at 2:01 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Tomas,
>
>> This patch fixes accumulating of the header
>> in case packet was requeued in the error path.
>>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> Cc: Marcel Holtmann <marcel@holtmann.org>
>> ---
>>  drivers/bluetooth/btsdio.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
>> index 58630cc..c422e89 100644
>> --- a/drivers/bluetooth/btsdio.c
>> +++ b/drivers/bluetooth/btsdio.c
>> @@ -91,6 +91,7 @@ static int btsdio_tx_packet(struct btsdio_data *data, struct sk_buff *skb)
>>
>>       err = sdio_writesb(data->func, REG_TDAT, skb->data, skb->len);
>>       if (err < 0) {
>> +             skb_pull(skb, 4);
>>               sdio_writeb(data->func, 0x01, REG_PC_WRT, NULL);
>>               return err;
>>       }
>
> thanks, but I already fixed that one manually in my tree :)
>
> Regards
>
> Marcel

Would you mind to queue it for 27 stable?  I'm always hitting this and
I guess I'm not only one.
http://marc.info/?l=linux-bluetooth&m=122513647106365&w=2

Thanks
Tomas
