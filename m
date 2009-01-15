Return-Path: <linux-kernel-owner+w=401wt.eu-S1763294AbZAOKiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763294AbZAOKiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbZAOKiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:38:05 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:48710 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZAOKiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Vur2xsAabSxqvlH4ByiexpdmBm0hyzU+sXgRyjUvhKlbWJfLuC4wFIt3F0p5nX+w8+
         quC/BLxVQgjdzZRQhpWqUrcJrG6dpVl4atArk0hsY6BSLgYmxGx9KY8RXfqnYt8nFapR
         IVFrgLLda0Dk/QPYNETpUh6cWmP4t2yMjpSfE=
Message-ID: <aec7e5c30901150238j7c065574u789d85f25739098e@mail.gmail.com>
Date: Thu, 15 Jan 2009 19:38:00 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "roel kluin" <roel.kluin@gmail.com>
Subject: Re: [RESEND][PATCH] early platform drivers V2
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       lethal@linux-sh.org, johnstul@us.ibm.com, gregkh@suse.de,
       mingo@redhat.com, tglx@linutronix.de
In-Reply-To: <25e057c00901150229g35d8e9bdn6a19585cbc9d15bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090114105436.18974.45429.sendpatchset@rx1.opensource.se>
	 <25e057c00901150229g35d8e9bdn6a19585cbc9d15bd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

Thanks for your feedback!

On Thu, Jan 15, 2009 at 7:29 PM, roel kluin <roel.kluin@gmail.com> wrote:
>> +                       if (id != -2) /* skip previously checked device */
>> +                               if (match_id == epdrv->requested_id)
>> +                                       goto skip;
>> +
>> +                       if (pdev->id == match_id)
>> +                               *match = pdev;
>> +
>> +skip:
>> +                       if (pdev->id > match_id)
>> +                               n++;
>
> you can replace the 10 lines above by:
>
> /* skip previously checked device */
> if ((id == -2 || match_id != epdrv->requested_id) && pdev->id == match_id)
>        *match = pdev;
> else if (pdev->id > match_id)
>        n++;

I agree that the code looks a bit special, but are you sure your
replacement is correct?

Will the "n++" happen in the case of (pdev->id == match_id)?

>> +                       if (epdrv->pdrv->probe(match)) {
>
> shouldn't this be
>
> if (!epdrv->pdrv->probe(match)) {

No, probe() returns 0 if things went well. Non-zero means error.

> I think k, n and i could get more descriptive names

Sure, why not! Care to give any suggestions? =)

/ magnus
