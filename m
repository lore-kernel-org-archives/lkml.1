Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYJTSB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYJTSB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 14:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYJTSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 14:01:48 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:35028 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbYJTSBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 14:01:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=rSNNpMcftI5ih8SUvjk1um//VprlNeeCbr2G3ydZFx/uXcrVGGG7kT5KJ55w7qPA7i
         vglhOdfarXq/7SH4T6FmYKye1sXRRyCLEsiDy0QLoZeq1RLsrk2PfhcyVPMAuk2A7X/2
         jk19XIidCTaLieWrK7+pQ1amV25A5J+pMA3rI=
Message-ID: <37219a840810201101g6382179ft8e3b03416aeeb957@mail.gmail.com>
Date: Mon, 20 Oct 2008 14:01:42 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Greg KH" <greg@kroah.com>
Subject: Re: Bug fix for pvrusb2 driver [was: Re: Kernel 2.6.26.5 -> 2.6.27.2 [USB REGRESSION] (USB -> D_STATE)]
Cc: "Mike Isely" <isely@pobox.com>, "Alan Stern" <stern@rowland.harvard.edu>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Oliver Neukum" <oliver@neukum.org>,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       "USB list" <linux-usb@vger.kernel.org>
In-Reply-To: <20081020172914.GA9624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0810201203530.2719-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.64.0810201134400.12643@cnc.isely.net>
	 <20081020172914.GA9624@kroah.com>
X-Google-Sender-Auth: 809c01d046cf43de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 1:29 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Oct 20, 2008 at 11:37:41AM -0500, Mike Isely wrote:
>>
>> I was incomplete in my previous response.  See further below for nack
>> and another patch...
>>
>>
>> On Mon, 20 Oct 2008, Alan Stern wrote:
>>
>>    [...]
>>
>> >
>> > Index: usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
>> > ===================================================================
>> > --- usb-2.6.orig/drivers/media/video/pvrusb2/pvrusb2-main.c
>> > +++ usb-2.6/drivers/media/video/pvrusb2/pvrusb2-main.c
>> > @@ -68,6 +68,16 @@ static void pvr_setup_attach(struct pvr2
>> >  #endif /* CONFIG_VIDEO_PVRUSB2_SYSFS */
>> >  }
>> >
>> > +static int pvr_pre_reset(struct usb_interface *intf)
>> > +{
>> > +   return 0;
>> > +}
>> > +
>> > +static int pvr_post_reset(struct usb_interface *intf)
>> > +{
>> > +   return 0;
>> > +}
>> > +
>> >  static int pvr_probe(struct usb_interface *intf,
>> >                  const struct usb_device_id *devid)
>> >  {
>> > @@ -109,7 +119,9 @@ static struct usb_driver pvr_driver = {
>> >     .name =         "pvrusb2",
>> >     .id_table =     pvr2_device_table,
>> >     .probe =        pvr_probe,
>> > -   .disconnect =   pvr_disconnect
>> > +   .disconnect =   pvr_disconnect,
>> > +   .pre_reset =    pvr_pre_reset,
>> > +   .post_reset =   pvr_post_reset,
>> >  };
>> >
>> >  /*
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>>
>> Nacked-by: Mike Isely <isely@pobox.com>
>>
>> There is already another patch ready to go which eliminates the reset
>> entirely.  It can be found here:
>>
>> http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4
>
> Will this patch be sent to the -stable group, to fix this regression in
> 2.6.27?  Or should they take Alan's fix instead?

Greg,

Please queue the patch that Mike Isely sent for 2.6.27.y -- It's not
in Mauro's tree yet, but it will get there eventually.  (it might take
him some before he does his next sync to git)

Reviewed-by: Michael Krufky <mkrufky@linuxtv.org>

Regards,

Mike Krufky
