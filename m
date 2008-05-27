Return-Path: <linux-kernel-owner+w=401wt.eu-S1757177AbYE0Hbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177AbYE0Hbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 03:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYE0Hbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 03:31:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:12669 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183AbYE0Hbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 03:31:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c3oTCRItiGtq+aspZloOt2u2VTlPL3gP59rVS/rvCyZImdht+s+/0ZTdIErBZ0wkQaxVaYnYtRrK0bsw2QACaU0B+qxyS5I+ddCV8+3N9oR+PavwG6xWoMv7QAsMFSdKzpGN9xeyamU0RRTfeb98mzXk4pWte42AysovLezpL84=
Message-ID: <a8e1da0805270031i20b472d3k1d6af806115f10aa@mail.gmail.com>
Date: Tue, 27 May 2008 15:31:38 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Cc: "Greg KH" <greg@kroah.com>, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080526235934.8a28bfba.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
	 <20080520172139.GA11666@kroah.com>
	 <a8e1da0805262342g2dec037eqfdf376e66459e758@mail.gmail.com>
	 <20080526235934.8a28bfba.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 2:59 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 27 May 2008 14:42:51 +0800 "Dave Young" <hidave.darkstar@gmail.com> wrote:
>
>> On Wed, May 21, 2008 at 1:21 AM, Greg KH <greg@kroah.com> wrote:
>> > On Tue, May 20, 2008 at 03:02:32AM -0700, Andrew Morton wrote:
>> >> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>> >>
>> >> > Converting class semaphore to mutex cause lockdep warnings due to
>> >> > class_interface_register/unregister will possible call device_add/del
>> >>
>> >> Shouldn't we just fix that?
>> >
>> > Um, no, that's a "feature" that some types of hardware and interfaces
>> > require.
>> >
>> > This is one reason I really don't like this type of conversion, it's
>> > causing lots of problems for no known gain.
>> >
>> > So I would just recommend dropping this patch set, the current "convert
>> > class semaphore to a mutex" patch in the -mm tree is already causing
>> > lockdep warnings, and trying to do something like this isn't really
>> > going to solve the root problem here.
>>
>> At last, I decide to give up.
>>
>> Andrew, I could not do more for this issue now, you can drop the
>> conversion patch if there's no suitable fix from others.
>>
>
> If that semaphore is being used as a mutex then we should convert it to
> a mutex (dammit).
>
> Leaving it implemented as a semphore is not the proper way of
> suppressing the lockdep warnings.  It would be better to convert it to
> a mutex then add suitable (and suitably commented) open-coded lockdep
> annotations to suppress the runtime warnings.

I agree.

>
> And afaik that's pretty much what your patch did, except you added that
> unpopular macro.  If instead of the macro we were to convert that patch
> to add open-coded lockdep annotation, what problems remain?
>
>
Actually I want a best fix which could be accepted by all of you, and
by me. It's not so easy.

I can give another try without the macro. Thanks.

---
Regards
dave
