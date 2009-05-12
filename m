Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbZELBkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbZELBkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 21:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbZELBki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 21:40:38 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:23450 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZELBkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 21:40:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=K8luqwJjMf58t+upcmIcEbGbGwgd2L6iKAiCvq6MznJA0z6PMowivV/QBSoAjKwK+g
         cGIHRNJTQroY0zcKYM4HZ9NeLri4RpsJkOJJiFnNBR9EEYlheo9EC9FRhWS3xPzr39sx
         evfv/WopfmLZ+lihcuJUN+YLUi0DpVRRFbL3I=
MIME-Version: 1.0
In-Reply-To: <20090511154122.GB6973@dtor-d630.eng.vmware.com>
References: <483a38b80905110444n7d55b967j70cf2639dff1c706@mail.gmail.com>
	 <20090511153808.GA6973@dtor-d630.eng.vmware.com>
	 <20090511154122.GB6973@dtor-d630.eng.vmware.com>
Date: Tue, 12 May 2009 10:40:38 +0900
Message-ID: <483a38b80905111840k6b7e7aaao9b70f17753bebada@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt 
	context
From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 12, 2009 at 12:41 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Mon, May 11, 2009 at 08:38:09AM -0700, Dmitry Torokhov wrote:
>> Hi,
>> On Mon, May 11, 2009 at 08:44:00PM +0900, Kwangwoo Lee wrote:
>> > From d5de0d22109de7564f9bf1df688acbe6b18f41db Mon Sep 17 00:00:00 2001
>> > From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
>> > Date: Mon, 11 May 2009 20:05:50 +0900
>> > Subject: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt context.
>> >
>> > This patch enhances pointer movements much smoother.
>> > The original patch is written by Thierry.
>> >
>> > --- a/drivers/input/touchscreen/tsc2007.c
>> > +++ b/drivers/input/touchscreen/tsc2007.c
>> > @@ -70,6 +70,7 @@ struct ts_event {
>> >  struct tsc2007 {
>> >     struct input_dev        *input;
>> >     char                    phys[32];
>> > +   struct work_struct      work;
>>
>> Every time I see a work_struct in a driver and don't see
>> cancel_work_sync() anywhere I know there are issues...
>>

Thanks for your comment. I also missed that thing, sorry.

> Also, why do we need to chain irq->timer->work now? Surely we can bypass
> the timer if we have to read in process context.

It's good point. I'll check again.
Thanks.

-- 
Kwangwoo Lee <kwangwoo.lee@gmail.com>
