Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYIRSib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYIRSib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 14:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYIRSiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 14:38:23 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:60636 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbYIRSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 14:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lAUhb8dy6Octs8CQToL1cLHriGsiMaCV7sN/r5+zCSnylO+6VuoJ+YJtmfn9bdxuMt
         LTSSsY9t5Nm1Q6AhgLUIJzIoqtyN1mLGp+HU6C9PrmVA7i4Iu4POk7RpqawP6TRgfqz6
         VcWEOVqHzKraRD19ec3pMp5QS7XCjuxHgS1+I=
Message-ID: <f17812d70809181138xb0e4d4bs8a6361bb038b5a6e@mail.gmail.com>
Date: Fri, 19 Sep 2008 02:38:21 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: kernel.h: add ARRAY_AND_SIZE() macro to complement ARRAY_SIZE().
Cc: "Ben Dooks" <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <20080918150624.GA3421@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080918132447.516309749@fluff.org.uk>
	 <20080918150624.GA3421@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 11:06 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Thu, Sep 18, 2008 at 02:24:47PM +0100, Ben Dooks wrote:
>> Move the ARRAY_AND_SIZE() macro from arch/arm/mach-pxa/generic.h
>> to a more useful position in include/linux/kernel.h. This macro
>> is very useful to registration functions that take an array and
>> the number of array elements in it as consecutive arguments.
>>
>> The macro also should ensure that mistakes where the wrong array
>> is used to the ARRAY_SIZE() macro is passed. It also makes it
>> easier to avoid wrapping registration function arguments.
>
>> --- linux-2.6.27-rc6-quilt4.orig/include/linux/kernel.h
>> +++ linux-2.6.27-rc6-quilt4/include/linux/kernel.h
>> @@ -43,6 +43,7 @@ extern const char linux_proc_banner[];
>>  #define IS_ALIGNED(x, a)             (((x) & ((typeof(x))(a) - 1)) == 0)
>>
>>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>> +#define ARRAY_AND_SIZE(arr) (arr), ARRAY_SIZE(arr)
>
> Just like ARRAY_SIZE, it is misnamed.
>

Any hint about the correct spelling?

> And it isn't obvious to what it expands. Hopefully arm people will
> remove it. :-)

This is handy to use, saving several key strokes and making the line
shorter. If it's not obvious to what it expands, there must be some
fix for it?
