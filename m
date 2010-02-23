Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0BWHb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 02:31:29 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42505 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0BWHb0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 02:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ani+D20YnCOZwTFAOeu2F3jxJiuP6OrZ11HLdXJk+ISQ4RN3HJWxZJsK2dDAl59b0P
         8tBgO6/ER0G5bMD1ULmTk8iICk9daGyaadV6jekugm8UB07GSaSLojtMY7HFbN811hum
         4s92tvbykfJB9v7KKQBEu073XM++YARMr7c1Q=
MIME-Version: 1.0
In-Reply-To: <20100223065953.GB32503@liondog.tnic>
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com>
	 <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com>
	 <20100223065953.GB32503@liondog.tnic>
Date: Tue, 23 Feb 2010 13:01:25 +0530
Message-ID: <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com>
Subject: Re: QUERY: Inclusion of header files in kernel header files
From: viresh kumar <viresh.linux@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>,
       viresh kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> Is this correct approach?
>>
>> Again, if i include device.h and resource.h, they must be included before bus.h.
>
> and this is the thing: all those other files which include
> <linux/amba/bus.h> either include <linux/device.h> and
> <linux/resource.h> directly or the last are being included indirectly
> through other headers.
>
> Baseline, struct device and struct resource's definitions have to be
> available before <linux/amba/bus.h> is included. That's why you have to
> include the bus.h header last.
>

We need to include device.h and resource.h at every place where we use bus.h.

Shouldn't it be responsibility of bus.h only? So that people don't
have to bother about bus.h
internal dependencies.

I think, ideally including any header file shouldn't give compilation
errors for types used in
included header file.

viresh kumar

On Tue, Feb 23, 2010 at 12:29 PM, Borislav Petkov
<petkovbb@googlemail.com> wrote:
> From: viresh kumar <viresh.linux@gmail.com>
> Date: Tue, Feb 23, 2010 at 12:13:35PM +0530
>
> Hi,
>
>> I have been through many kernel header files and have found that kernel header
>> files at many places don't include other header files which they have
>> dependency upon.
>>
>> For example:
>> <linux/amba/bus.h> uses struct device and struct resource and it doesn't
>> include <linux/device.h> and <linux/resource.h> header files.
>>
>> Now, whenever i try to include bus.h, i have to include device.h and resource.h.
>>
>> Is this correct approach?
>>
>> Again, if i include device.h and resource.h, they must be included before bus.h.
>
> and this is the thing: all those other files which include
> <linux/amba/bus.h> either include <linux/device.h> and
> <linux/resource.h> directly or the last are being included indirectly
> through other headers.
>
> Baseline, struct device and struct resource's definitions have to be
> available before <linux/amba/bus.h> is included. That's why you have to
> include the bus.h header last.
>
>> Now this will disturb the alphabetical ordering of including header files
>> sometimes. (not in this example)
>
> I don't think there's such thing as alphabetical header ordering and if
> it were it would be rather dumb thing to do.
>
> Hope this helps.
>
> --
> Regards/Gruss,
>    Boris.
>
