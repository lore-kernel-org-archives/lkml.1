Return-Path: <linux-kernel-owner+w=401wt.eu-S1757450AbYCCWKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450AbYCCWKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYCCWKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:10:22 -0500
Received: from submit01.sysedata.no ([195.159.29.244]:45790 "EHLO
	submit01.sysedata.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbYCCWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:10:22 -0500
Message-ID: <47CC7748.3030004@db.org>
Date: Mon, 03 Mar 2008 23:10:16 +0100
From: "Alfred E. Heggestad" <aeh@db.org>
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: driver for USB VoIP phones with CM109 chipset
References: <47AB5012.20509@db.org> <200802091023.02580.oliver@neukum.org>
In-Reply-To: <200802091023.02580.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Donnerstag, 7. Februar 2008 19:38:10 schrieb Alfred E. Heggestad:
>> +static void buzz(struct cm109_dev *dev, int on)
>> +{
>> +       int ret;
>> +
>> +       if (dev == NULL) {
>> +               err("buzz: dev is NULL");
>> +               return;
>> +       }
>> +
>> +       dbg("Buzzer %s", on ? "on" : "off");
>> +       if (on)
>> +               dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
>> +       else
>> +               dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
>> +
>> +       ret = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
>> +       if (ret)
>> +               err("%s - usb_submit_urb failed %d", __FUNCTION__, ret);
>> +}
>> +
>> +static int input_ev(struct input_dev *idev, unsigned int type,
>> +                   unsigned int code, int value)
>> +{
>> +       struct cm109_dev *dev = input_get_drvdata(idev);
>> +       unsigned long flags;
>> +
>> +#ifdef CM109_DEBUG
>> +       info("input_ev: type=%u code=%u value=%d", type, code, value);
>> +#endif
>> +
>> +       if (type != EV_SND)
>> +               return -EINVAL;
>> +
>> +       switch (code) {
>> +       case SND_TONE:
>> +       case SND_BELL:
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       spin_lock_irqsave(&cm109_buzz_lock, flags);
>> +       buzz(dev, value);
>> +       spin_unlock_irqrestore(&cm109_buzz_lock, flags);
>> +
>> +       return 0;
>> +}
> 
> What makes you sure you finished the URB to switch the buzzer on before
> you try to switch it off again? It seems that you might be attempting to
> manipulate a live URB there if you hit the window.
> 

thanks for the hint. could you let me know how I can fix this properly,
or point me to some USB driver code that implements this correctly.. ?


/alfred

> 	Regards
> 		Oliver

