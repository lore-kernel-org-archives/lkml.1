Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYIQS27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYIQS27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYIQS2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:28:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:3573 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYIQS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OZb0YuMCvlin7+CTXJeiC6gXQe+nTytVCW15bjm8vgrHzcT+NTm/lDb+tTaK6uCLcd
         BBD9MWo4u382L+zGj+7goZKc8QLFUhvpD/eeU0holVg7D4iiuace6Mlz5w6IPkMnux+G
         PwUxBh12t52khiQNR1rzKF08EAL7KBNekaoI0=
Message-ID: <86802c440809171128y17cbb6b6mca9c5beae0b2dcd4@mail.gmail.com>
Date: Wed, 17 Sep 2008 11:28:48 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [PATCH 5/6] apci: dump slit with printk(KERN_ACPI...)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080917181856.GA5524@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <1221640067-24389-6-git-send-email-yhlu.kernel@gmail.com>
	 <20080917181856.GA5524@joi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 11:19 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> On Wed, Sep 17, 2008 at 01:27:46AM -0700, Yinghai Lu wrote:
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>
>> ---
>>  drivers/acpi/numa.c |    9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> Index: linux-2.6/drivers/acpi/numa.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/acpi/numa.c
>> +++ linux-2.6/drivers/acpi/numa.c
>> @@ -150,6 +150,15 @@ static __init int slit_valid(struct acpi
>>  {
>>       int i, j;
>>       int d = slit->locality_count;
>> +     printk(KERN_DEBUG KERN_ACPI "ACPI: SLIT: nodes = %d\n", d);
>> +     for (i = 0; i < d; i++) {
>> +             printk(KERN_DEBUG KERN_ACPI "  ");
>> +             for (j = 0; j < d; j++)  {
>> +                     u8 val = slit->entry[d*i + j];
>> +                     printk(KERN_CONT KERN_ACPI " %d", val);
>> +             }
>> +             printk(KERN_CONT KERN_ACPI "\n");
>> +     }
>
> It will produce something like this:
> <7><acpi>ACPI: SLIT: nodes = %d\n
> <7><acpi>  <acpi> %d<acpi> %d<acpi> %d<acpi> %d<acpi>\n
>
> bit wrong... ;)

did you check v6...?

YH
