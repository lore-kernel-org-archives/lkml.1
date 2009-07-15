Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZGOUYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZGOUYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbZGOUYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:24:51 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:46485 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbZGOUYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:24:50 -0400
MIME-Version: 1.0
In-Reply-To: <20090715134855.GB2538@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <20090714175201.GB14661@dtor-d630.eng.vmware.com>
	 <20090715134855.GB2538@elf.ucw.cz>
Date: Wed, 15 Jul 2009 13:24:49 -0700
Message-ID: <d6200be20907151324t7c133d49ofedf02efda4054cd@mail.gmail.com>
Subject: Re: Support for synaptic touchscreen in HTC dream
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 6:48 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Tue 2009-07-14 10:52:12, Dmitry Torokhov wrote:
>> On Tue, Jul 14, 2009 at 12:06:34PM +0200, Pavel Machek wrote:
>> > From: Arve Hj?nnev?g <arve@android.com>
>> >
>> > This adds support for synaptic touchscreen, used in HTC dream
>> > cellphone.
>> >
>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> This is pretty large body of code, could we get a sign-off from Arve as
>> well since he seems to be the author?
>
> Arve?
>

The original patches has my sign-offs. Can you just keep that and add
a line describing your changes before your sign-off?

...
>> > +static struct workqueue_struct *synaptics_wq;
>>
>> Do we need a separate workqueue? Is reading the device that slow that we
>> can use keventd?
>

keventd has two problems. First, other work runs on it that can take
more than 12.5ms. This will case dropped events. Second, the i2c bus
sometimes locks up, which in turns would cause this driver to block
keventd for seconds.

...
>> > +   if (client->irq) {
>> > +           ret = request_irq(client->irq, synaptics_ts_irq_handler,
>> > +                             0, client->name, ts);
>>
>> I think threaded IRQ will fit the bill and will take care of
>> IRQ/workqueue shutdown races. Of course you still need to use workqueue
>> if polling.
>
> I guess we'll just strip polling version for now?

Sounds good to me.

-- 
Arve Hjønnevåg
