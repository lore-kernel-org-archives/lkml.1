Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZGUMSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZGUMSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZGUMSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:18:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:28013 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZGUMSl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:18:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kUncOevpiOAfgXcfOYcCQQPNAQOHmyqf7tWvioiefBUniu1KxkM8vVfiRWJKks+1cd
         G66xCK+lkvAIYSh622TIR84+mOGIii31RGW4DR+Bdwg1PTA8TZSqqGpLdA2P3yPRxrA0
         HLrUhC8mNhCoharHYJn7ge1HnUlHD7AkQCkHU=
MIME-Version: 1.0
In-Reply-To: <20090721113642.GC13286@sirena.org.uk>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	 <20090715133627.GA2538@elf.ucw.cz>
	 <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <20090721105924.GK4133@elf.ucw.cz>
	 <20090721113642.GC13286@sirena.org.uk>
Date: Tue, 21 Jul 2009 17:48:40 +0530
Message-ID: <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
From: Trilok Soni <soni.trilok@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jul 21, 2009 at 5:06 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Tue, Jul 21, 2009 at 12:59:25PM +0200, Pavel Machek wrote:
>
> This looks like an unrelated (but useful) change:
>
>>   *
>> + * http://www.synaptics.com/sites/default/files/511_000099_01F.pdf
>>   */
>
> This too:
>
>>  static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
>>  {
>> +/*
>> + * This sensor sends two 6-byte absolute finger reports, an optional
>> + * 2-byte relative report followed by a status byte. This function
>> + * reads the two finger reports and transforms the coordinates
>
> Worth splitting them out?
>
>> +static irqreturn_t synaptics_ts_hardirq(int irq, void *dev_id)
>> +{
>> +     disable_irq_nosync(irq);
>> +     return IRQ_WAKE_THREAD;
>
> Are you sure that this is going to work?  The IRQ thread code will not
> call the thread function if the IRQ is marked as disabled so the thread
> won't actually get called and the interrupt will just stay disabled (see
> irq_thread() in kernel/irq/manage.c).  As far as I can see the threaded
> IRQ support can't be used for devices on interrupt driven buses that
> can't interact with the hardware in hardirq context but I might be
> missing something here.
>

I think threaded irqs are used in USB drivers too, I can't locate the
patches link for that.



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
