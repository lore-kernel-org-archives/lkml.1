Return-Path: <linux-kernel-owner+w=401wt.eu-S1757093AbZB0CLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093AbZB0CLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZB0CLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:11:31 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:49449 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZB0CLa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:11:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ry2IDwieztDCbzQzhy+Ixz/mkc5u/HAq4eDdFWGuzYcFe/cLPggg28giErUhEA7ODB
         k0EaUTNdjw3dBMcXTPISSqTxd8/bHBllTdFUCXNC3wpzWCtocRyuo8CqXeF7aPPxqykf
         XQzdrz807gm8OpRVAg6Dz1UNqiAH9UrbgEEtQ=
MIME-Version: 1.0
In-Reply-To: <5d5443650902252301l19d08e67t54c1cea004442be2@mail.gmail.com>
References: <20090225044730.GA9106@july>
	 <5d5443650902252301l19d08e67t54c1cea004442be2@mail.gmail.com>
Date: Fri, 27 Feb 2009 11:11:27 +0900
X-Google-Sender-Auth: b50f21ba67b7b66a
Message-ID: <9c9fda240902261811g49483f9fk9ac7945834b8764@mail.gmail.com>
Subject: Re: [PATCH] Input notifier support
From: Kyungmin Park <kmpark@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 26, 2009 at 4:01 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
>> diff --git a/drivers/input/input.c b/drivers/input/input.c
>> index 1730d73..7e96635 100644
>> --- a/drivers/input/input.c
>> +++ b/drivers/input/input.c
>> @@ -274,6 +274,8 @@ void input_event(struct input_dev *dev,
>>                add_input_randomness(type, code, value);
>>                input_handle_event(dev, type, code, value);
>>                spin_unlock_irqrestore(&dev->event_lock, flags);
>> +               if (type == EV_KEY)
>> +                       input_notifier_call_chain(value, &code);
>
> This check will be done for every input_report_xxx calls, even for
> touchscreen events (in which case of course it will fail), and I don't
> think this is optimal solution. Users should be given an option to
> disable this if they don't need this notification mechanism.
>
> How about moving this to input_report_key?

Good, Thank you for point it. I will move it to input_report_key.

Thank you,
Kyungmin Park
