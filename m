Return-Path: <linux-kernel-owner+w=401wt.eu-S1755431AbYIPPHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbYIPPHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIPPHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:07:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbYIPPHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:07:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hGFxHiSw0t4zpofL7x9A4QnLNb+zJ6GLByNVNq4FRz7A4gOC6/UtKoUIg06EUjP3U
	NlcguLp5NV7vL3bWjYMmg==
Message-ID: <da824cf30809160807y721a6952ub1cd6966d960b7bd@mail.gmail.com>
Date: Tue, 16 Sep 2008 08:07:03 -0700
From: "Grant Grundler" <grundler@google.com>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for CX700)
Cc: "=?UTF-8?Q?Bruno_Pr=C3=A9mont?=" <bonbons@linux-vserver.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>
In-Reply-To: <48CEC8F2.4040904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080911193511.7960bc82@neptune.home>
	 <48CE22E5.9090403@kernel.org> <20080915190242.58d21a8f@neptune.home>
	 <48CEC8F2.4040904@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 1:43 PM, Tejun Heo <tj@kernel.org> wrote:
...
>>   5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000
>
> Whee... That's unusally high realloc count but I'm not sure whether it
> indicates actual problem or it's just the drive's way of saying I'm
> okay.  But this does look quite suspicious.

The "raw" values are "vendor defined".
Often the 6 bytes of raw data are split up into  1 or 2 byte wide fields.

Any volunteers to submit a patch to smartmontools to dump
"raw values" as hexidecimal by default?

(8589934592000 == 0x7D000000000)

>> 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       441778176
>
> Hmmm.. Do you happen to have drives of the same model?  If so, can you
> please check what other drives are reporting?

441778176 == 0x1a550000

Need to see if the vendor will provide documentation to decode these values.

AFAICT, it's not safe to directly compare raw values between vendors since
the raw values don't mean exactly the same thing (e.g. more aggressive retries
might result in few reallocations.)

hth,
grant

>
> Thanks.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
