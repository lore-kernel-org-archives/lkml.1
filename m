Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbZBEW3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbZBEW3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbZBEW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:29:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:58782 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZBEW3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ck/cAwMPFAAQoLYh/ghHXZ21eY4gdeQjFAzvdJ1wVZQRouMxFH42VOW9AywN15KAtp
         Mvh4YHuxYxgvrJUxKqfxtltifJ6deyo/I0DEvtLNelUub+wQ3Y1fozL+sDfa2J8hVLOp
         Sb+tBXIAso+allJN0o0EGlGuPqmklgpDkwXVc=
MIME-Version: 1.0
In-Reply-To: <20090205141250.cf66e663.akpm@linux-foundation.org>
References: <1233828453-13311-1-git-send-email-cooloney@kernel.org>
	 <1233828453-13311-4-git-send-email-cooloney@kernel.org>
	 <20090205141250.cf66e663.akpm@linux-foundation.org>
Date: Thu, 5 Feb 2009 17:29:18 -0500
Message-ID: <8bd0f97a0902051429q2b76c7b7nf4187178b73f979@mail.gmail.com>
Subject: Re: [PATCH 3/5] Blackfin SPI Driver: fix NULL pointer crash
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 17:12, Andrew Morton wrote:
> On Thu,  5 Feb 2009 18:07:31 +0800 Bryan Wu wrote:
>> From: Mike Frysinger <vapier.adi@gmail.com>
>> fix NULL pointer crash when cleaning up from invalid platform resources
>>
>> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  drivers/spi/spi_bfin5xx.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
>> index ce24d5e..b6098b5 100644
>> --- a/drivers/spi/spi_bfin5xx.c
>> +++ b/drivers/spi/spi_bfin5xx.c
>> @@ -1240,6 +1240,9 @@ static void bfin_spi_cleanup(struct spi_device *spi)
>>  {
>>       struct chip_data *chip = spi_get_ctldata(spi);
>>
>> +     if (!chip)
>> +             return;
>> +
>>       if ((chip->chip_select_num > 0)
>>               && (chip->chip_select_num <= spi->master->num_chipselect))
>>               peripheral_free(ssel[spi->master->bus_num]
>
> This one looks like 2.6.29 material to me.
>
> If you believe that it should be backported to earlier kernels then
> please let me know.  indicating whcih kernel versions would help things
> a bit, too.

including with 2.6.29 would be a good thing ... we havent quite synced
up our development process enough yet to do that kind of tracking, so
all of our stuff just goes into "the next thing" ...
-mike
