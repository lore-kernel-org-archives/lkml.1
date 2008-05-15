Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbYEOPli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbYEOPli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbYEOPl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:41:29 -0400
Received: from mail11b.verio-web.com ([204.202.242.87]:2495 "HELO
	mail11b.verio-web.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755506AbYEOPl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:41:28 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 May 2008 11:41:28 EDT
Message-ID: <482C5812.9090903@sensoray.com>
Date: Thu, 15 May 2008 08:34:42 -0700
From: Dean Anderson <dean@sensoray.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Trent Piepho <xyzzy@speakeasy.org>
CC: Greg KH <greg@kroah.com>, Markus Rechberger <mrechberger@gmail.com>,
       video4linux-list@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, mchehab@infradead.org,
       v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
References: <20080514205927.GA13134@kroah.com> <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com> <20080515024141.GB21941@kroah.com> <Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0805142006130.23876@shell4.speakeasy.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam: [F=0.0100000000; S=0.010(2008040101); MH=0.500(2008040918)]
X-MAIL-FROM: <dean@sensoray.com>
X-SOURCE-IP: [161.58.148.42]
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trent Piepho wrote:
> On Wed, 14 May 2008, Greg KH wrote:
>   
>> On Thu, May 15, 2008 at 03:17:42AM +0200, Markus Rechberger wrote:
>>     
>>> Hi Dean, Greg,
>>>       
>> Adding dean to the cc: line...  :)
>>     
>>> On 5/14/08, Greg KH <greg@kroah.com> wrote:
>>>       
>>>> From: Dean Anderson <dean@sensoray.com>
>>>>
>>>>         
>> <big patch snipped>
>>
>>     
>>> Why do you do those conversions in kernelspace?
>>> ffmpeg/libswscale has optimized code for colourspace conversions.
>>> I know a few drivers do that in kernelspace but it's way more flexible
>>> in userspace and depending on the optimization requires less CPU
>>> power.
>>>       
>> I thought they were there as needed by some V4L1 applications, but that
>> code was recently removed by Dean I think.  If they don't need to be
>> there, and userspace apps can properly handle the different colorspace,
>> then I'll be glad to remove them.
>>     
>
> Virtually all apps (V4L1 & 2) can handle YUV and RGB colorspaces.
> Certainly all the major ones do and all the major libraries as well.
>
> The problem is when the device only supports some vendor specific or
> otherwise very uncommon format.  In that case not doing the conversion in
> the kernel means the device won't work with any existing software without
> patches.  In this case, while it's not "the right way", drivers often end
> up including an in kernel conversion for pragmatic reasons.
>
> This was a problem with the bayer format, but now userspace support for
> that format is more common.
>   

I agree the conversions don't belong in a driver. For the record, the 
following are done in the 2255 hardware: V4L2_PIX_FMT_GREY and 
V4L2_PIX_FMT_YUV422P.

Since planar YUV formats such as V4L2_PIX_FMT_YUV422P are still not that 
well supported, is it possible to keep at least one packed YUV 
format(V4L2_PIX_FMT_YUYV) in the driver?  If not, let me know.  I will 
strongly suggest that the hardware Engineers add YUY2 or YUYV on board 
in the DSP firmware.  Thanks, Dean










