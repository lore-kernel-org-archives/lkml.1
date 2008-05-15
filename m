Return-Path: <linux-kernel-owner+w=401wt.eu-S1753485AbYEOQ54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbYEOQ54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYEOQ5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:57:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20236 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbYEOQ5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:57:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dADzBW2jQ6A3J5weba/wNbgHN2PHHvKCBUkX3pZzKaxwIxBEkR3Gsz6JIinvVsHvOaMYQSn6IhGIYD0MwmLPgf34KPHKHUi8rf4FLGT+o2Go17Mv64c8SbOmfc6ADfGdPOH6Da05gYLe8/JiyWZTMOie3Z3IbMkqK40g4o25OrU=
Message-ID: <d9def9db0805150957y2551bb19taf751b275decf79e@mail.gmail.com>
Date: Thu, 15 May 2008 18:57:43 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Dean Anderson" <dean@sensoray.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, "Greg KH" <greg@kroah.com>,
       video4linux-list@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org
In-Reply-To: <482C5812.9090903@sensoray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514205927.GA13134@kroah.com>
	 <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
	 <20080515024141.GB21941@kroah.com>
	 <Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
	 <482C5812.9090903@sensoray.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/08, Dean Anderson <dean@sensoray.com> wrote:
>>
>> Virtually all apps (V4L1 & 2) can handle YUV and RGB colorspaces.
>> Certainly all the major ones do and all the major libraries as well.
>>
>> The problem is when the device only supports some vendor specific or
>> otherwise very uncommon format.  In that case not doing the conversion in
>> the kernel means the device won't work with any existing software without
>> patches.  In this case, while it's not "the right way", drivers often end
>> up including an in kernel conversion for pragmatic reasons.
>>
>> This was a problem with the bayer format, but now userspace support for
>> that format is more common.
>>
>
> I agree the conversions don't belong in a driver. For the record, the
> following are done in the 2255 hardware: V4L2_PIX_FMT_GREY and
> V4L2_PIX_FMT_YUV422P.
>
> Since planar YUV formats such as V4L2_PIX_FMT_YUV422P are still not that
> well supported, is it possible to keep at least one packed YUV
> format(V4L2_PIX_FMT_YUYV) in the driver?  If not, let me know.  I will
> strongly suggest that the hardware Engineers add YUY2 or YUYV on board
> in the DSP firmware.  Thanks, Dean
>

Maybe it's better to fix up the corresponding application? If someone
wants to get those devices work he already either has to upgrade his
system or compile it manually at the moment.
With libswscale it's just a few lines of code to convert the formats
with a decent performance.
Seems like the demand of conversions is also growing for the future.

Markus
