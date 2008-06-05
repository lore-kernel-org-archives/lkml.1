Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbYFEMA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbYFEMA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYFEMAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:00:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:48896 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbYFEMAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:00:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sodxIl550tmIAMas/NGsEFIWI3vHBcdUcmp626qKnq+8PGYvj08RM5Cynx0pbB1e56
         rWOkIPW31V8UnTzeBr0pJYciUEpxW0iqFk3e9jWjMJF1NUlta6wFJ92JrfvAjUrY5TOx
         BpZhfCxzVNFQRpVjS+GfcNgdLBH/7KCzCovhE=
Message-ID: <87a5b0800806050500pa48f081j75fa58e696ed8cc8@mail.gmail.com>
Date: Thu, 5 Jun 2008 13:00:03 +0100
From: "Will Newton" <will.newton@gmail.com>
To: me@felipebalbi.com
Subject: Re: [PATCH] fsl_usb2_udc: Add a wmb before priming endpoint.
Cc: linux-usb@vger.kernel.org,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>, leoli@freescale.com
In-Reply-To: <20080603172415.GB29125@kedavra.cpe.vivax.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87a5b0800806030820i16b36366qf199e1c56d729fbe@mail.gmail.com>
	 <20080603172415.GB29125@kedavra.cpe.vivax.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2008 at 6:24 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> On Tue, Jun 03, 2008 at 04:20:25PM +0100, Will Newton wrote:
>> Add a wmb to fsl_queue_td before priming the endpoint. This ensures that the
>> modifications to the QH are seen by the hardware.
>>
>> Signed-off-by: Will Newton <will.newton@gmail.com>
>> ---
>>  drivers/usb/gadget/fsl_usb2_udc.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/fsl_usb2_udc.c
>> b/drivers/usb/gadget/fsl_usb2_udc.c
>> index 1868754..dd06a5b 100644
>> --- a/drivers/usb/gadget/fsl_usb2_udc.c
>> +++ b/drivers/usb/gadget/fsl_usb2_udc.c
>> @@ -653,6 +653,8 @@ static int fsl_queue_td(struct fsl_ep *ep, struct
>> fsl_req *req)
>>                       | EP_QUEUE_HEAD_STATUS_HALT));
>>       dQH->size_ioc_int_sts &= temp;
>>
>> +     wmb();
>
> checkpatch.pl will complain that there's not comment above the memory
> barrier. Could you just add it and in one line summarize why wmb()??

Yes, I'll do that and resend the patch along with the rest of the series I have.

My checkpatch does not seem to complain about the missing comment btw.
