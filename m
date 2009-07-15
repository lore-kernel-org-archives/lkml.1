Return-Path: <linux-kernel-owner+w=401wt.eu-S1755788AbZGORdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbZGORdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZGORdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:33:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:6013 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZGORdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VeYXJc+Nkd9ucGxz+F+61ju3c+MsS/K3RbHyIgG/lOzORBek90e3C37kt/R0ckZreD
         xarlYJ/72MvnugP4jDngdJ/unCt0+Cv4bz5qvB2cwrc9yenOggWMGfrJ2/VCT07E2R2M
         lpR22NxMfbhvRswMi0xPy6wtU0Ngv/AYftn7I=
MIME-Version: 1.0
In-Reply-To: <20090715133627.GA2538@elf.ucw.cz>
References: <20090714100634.GA4054@elf.ucw.cz>
	 <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com>
	 <20090715133627.GA2538@elf.ucw.cz>
Date: Wed, 15 Jul 2009 23:03:02 +0530
Message-ID: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
Subject: Re: Support for synaptic touchscreen in HTC dream
From: Trilok Soni <soni.trilok@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, dmitry.torokhov@gmail.com,
       dtor@mail.ru, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Wed, Jul 15, 2009 at 7:06 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
>> > +static void decode_report(struct synaptics_ts_data *ts, u8 *buf)
>> > +{
>>
>> some documentation about this logic would be great.
>
> Arve, can you help here?
>
>
>> > +       int pos[2][2];
>> > +       int f, a;
>> > +       int base = 2;
>> > +       int z = buf[1];
>> > +       int w = buf[0] >> 4;
>> > +       int finger = buf[0] & 7;
>> > +       int finger2_pressed;
>> > +
>> > +       for (f = 0; f < 2; f++) {
>> > +               u32 flip_flag = SYNAPTICS_FLIP_X;
>> > +               for (a = 0; a < 2; a++) {
>> > +                       int p = buf[base + 1];
>> > +                       p |= (u16)(buf[base] & 0x1f) << 8;
>> > +                       if (ts->flags & flip_flag)
>> > +                               p = ts->max[a] - p;
>> > +                       if (ts->flags & SYNAPTICS_SNAP_TO_INACTIVE_EDGE) {
>
>
>> > +static irqreturn_t synaptics_ts_irq_handler(int irq, void *dev_id)
>> > +{
>> > +       struct synaptics_ts_data *ts = dev_id;
>> > +
>> > +       disable_irq(ts->client->irq);
>>
>> disable_irq_nosync or convert this to request_threaded_irq(...).
>> Please see recent discussion on linux-input for MAX key switch
>> controller.
>
> Do you have a link? (I replaced it with disable_irq_nosync, if that is
> enough...)
>

link: http://patchwork.kernel.org/patch/35515/

>> > +static int synaptics_ts_probe(
>> > +       struct i2c_client *client, const struct i2c_device_id *id)
>> > +{
>>
>> __devinit ?
>
> Ok.
>
>> > +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>>
>> check for SMBUS? I have added linux-i2c as this driver has i2c bits,
>> so not removing any code.
>
> I guess this driver is only probed on mach-pxa... on machines that
> have the neccessary hardware.

Because this driver is using smbus i2c apis, it will be good to add
that check too.

>
>> > +               printk(KERN_ERR "synaptics_ts_probe: need I2C_FUNC_I2C\n");
>>
>> dev_xxx/pr_xxx friends?
>
> Fixed all occurences.
>
>
>> > +       ts->input_dev = input_allocate_device();
>> > +       if (ts->input_dev == NULL) {
>> > +               ret = -ENOMEM;
>> > +               pr_err("synaptics: Failed to allocate input device\n");
>> > +               goto err_input_dev_alloc_failed;
>> > +       }
>> > +       ts->input_dev->name = "synaptics-rmi-touchscreen";
>>
>> other parameters of input_dev, like vendor, bus etc.,
>
> Ok, what are those for? I can probably invent some dummy values, but...

May be vendor, product, version would be good to add.

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
