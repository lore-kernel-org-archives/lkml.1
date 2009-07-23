Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZGWJVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZGWJVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 05:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZGWJVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 05:21:12 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:61760 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZGWJVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 05:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fI4ZWiRShHYWaZ41eZAeDufegdkXSocmIbYi2hOLwYDsifZGKOB/KiiDK/nmC6nzno
         Z4PpAmdGBeyDelP+RIMfxXVIsPb/epjGD5UE8fVjVA4L+ic8PfKqFoEOFQf6vLJg8koV
         eaMQ/m1M+XEquynPET2CwBBq90foS09tmNekA=
MIME-Version: 1.0
In-Reply-To: <cone.1248339143.133822.15136.1000@arca>
References: <1247672919-13089-1-git-send-email-petkovbb@gmail.com>
	 <cone.1247683003.40459.21332.1000@deskpiie>
	 <20090723082904.GE3997@dtor-d630.eng.vmware.com>
	 <cone.1248339143.133822.15136.1000@arca>
Date: Thu, 23 Jul 2009 11:21:10 +0200
Message-ID: <9ea470500907230221m1664be8ft2aaf63d2550de6f8@mail.gmail.com>
Subject: Re: [PATCH] acerhdf: convert to dev_pm_ops
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, lenb@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 10:52 AM, Peter Feuerer<peter@piie.net> wrote:
> Hi Dmitry,
>
> Dmitry Torokhov writes:
>
>> On Wed, Jul 15, 2009 at 08:36:43PM +0200, Peter Feuerer wrote:
>>>
>>> Works fine here, thanks!
>>>
>>> Acked-by: Peter Feuerer <peter@piie.net>
>>
>> Umm, did you test suspend-to-disk? As far as I understand the new
>> suspend() and resume() methods are onluy used for S2R and for S2D you need
>> to use freeze() and thaw().
>
> No, I didn't test S2D, will have a look at this issue. Thanks for pointing
> out!

Dmitry's right, suspend() and resume() are used only for S2R. Since
the only thing we do when suspending/hibernating is set fan speed to
auto, we might just as well replicate those functions to .freeze() and
.thaw().

/me testing...

-- 
Regards/Gruss,
Boris
