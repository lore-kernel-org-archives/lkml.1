Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYILT3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYILT3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 15:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbYILT3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 15:29:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:33754 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYILT3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 15:29:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=bX773KSLrYcwzljNeSu5PUSif8ofLkgNqY3fiMY+7USf6DPEYzVlQjODVjtA7ayyHn
         FWagz0aahrIT2lHRHK+qGMnK09jOztoycdCGS+n+3GxS+3dmfcNqMY+I5ybHqbv50/+9
         4e3cWyi8fp+YMj2Y9IfgJ05tgMbmHBN6EOhT8=
Message-ID: <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
Date: Fri, 12 Sep 2008 12:29:41 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] apci: dump slit
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080912122031.eca8723e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080912122031.eca8723e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 12:20 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 12 Sep 2008 11:17:48 -0700
> Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  drivers/acpi/numa.c |    8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> Index: linux-2.6/drivers/acpi/numa.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/acpi/numa.c
>> +++ linux-2.6/drivers/acpi/numa.c
>> @@ -150,6 +150,14 @@ static __init int slit_valid(struct acpi
>>  {
>>       int i, j;
>>       int d = slit->locality_count;
>> +     printk(KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
>> +     for (i = 0; i < d; i++) {
>> +             for (j = 0; j < d; j++)  {
>> +                     u8 val = slit->entry[d*i + j];
>> +                     printk(" %d", val);
>> +             }
>> +             printk("\n");
>> +     }
>>       for (i = 0; i < d; i++) {
>>               for (j = 0; j < d; j++)  {
>>                       u8 val = slit->entry[d*i + j];
>
> why?

to see how wrong could be set by BIOS.

YH
