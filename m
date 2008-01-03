Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYACXJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYACXJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:09:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYACXJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:09:03 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:54812 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbYACXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:09:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Aj9PVRWUZW6Iq6KRgJ0MsReOCpODLLDYho8oUAwrkSTJ0lcwJ5BlIhasPATPPpwAF7oa/CraPu0EkJDmRDbeew5gmeBLJIpupfeMJ4/RTAJU2RQn1gFi/lhK/HNK2xb/JD8PE51c/Il5zYc+WOrEspH33Q6ZrBRJIaxibIdXo1M=
Date: Thu, 3 Jan 2008 15:08:55 -0800
From: mgross <640e9920@gmail.com>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Xiaofan Chen <xiaofanc@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] libusb / in-kernel usb driver criteria (was: USB driver
	for talking to the Microchip PIC18 boot loader)
Message-ID: <20080103230855.GA5892@mgross-t43>
References: <20071229193409.GA20188@mgross-t43> <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org> <20071230035349.GA4741@mgross-t43> <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com> <477BED13.4060403@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477BED13.4060403@grupopie.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 07:59:15PM +0000, Paulo Marques wrote:
> Xiaofan Chen wrote:
>> On Dec 30, 2007 11:53 AM, mgross <640e9920@gmail.com> wrote:
>>> [...]
>>> What is the linux-usb policies on new drivers that could be
>>> implemented in user space?  When does a kernel driver make sense over
>>> a libusb one?
>> That would be interesting to know.
>
> I myself have been faced with this question before, and I think we should 
> try to clarify this by adding a document with some guidelines to 
> Documentation/usb.
>
> So, to get the ball rolling, here are some factors that IMHO help decide in 
> which side to implement a driver:
>
>  - if the driver ties a hardware device to an existing in-kernel interface 
> (network, block, serial, bluetooth, video4linux, etc.), it should probably 
> be implemented in-kernel.

Agreed, I think this is clear.

>
>  - on the other hand, if the driver doesn't use an existing kernel 
> interface and creates a new user-visible interface that is going to be used 
> by a single userspace application, it should probably be done in userspace.
>

To me this is still grey, and comes down to opinions of style.  I
happen to like the way code looks when things are split up into
drivers (that know a lot about the hardware and protects it from data
that will turn it into a brick) and application code that talks to the
interface defined by the driver.

The libusb based applications I've seen tend to be quite convoluted
and do a poor job of separating the USB protocol from the application
protocol for talking to the device.

I don't think there is a clear way to define when to do a kernel
driver vrs just use a libusb thing, other than if no one does a kernel
driver for a device then users are stuck with the libusb applications.

If someone steps up and does one and is willing to support it, then to
me its like, "whatever" add the driver. 

BTW I don't know if its worth to code bloat for my driver as I ponder
this issue now.  I like the way non-libusb applications look more but
I guess I could create a lib of api-wrappers to the libusb interface
and use that, but I really think its less code to create a simple
kernel driver.  

If it where up to me, I would say if the LOC is smaller to have a
kernel driver and application then a kernel driver is justified
otherwise its not.

--mgross



>  - if it is going to be used by several applications it could still be 
> implemented as a library, but it starts moving into the gray area.
>
>  - performance might be a reason to move to kernel space, but I don't think 
> it matters for transfer rates below 10Mbytes/sec or so.
>
> Anyway, this is just MHO, so feel free to discuss this further. I'm simply 
> volunteering to sum up this thread into a patch to add a 
> Documentation/usb/userspace_drivers.txt (or something like that), so that 
> we can help future developers decide where to write their drivers.
>
> -- 
> Paulo Marques - www.grupopie.com
>
> "Very funny Scotty. Now beam up my clothes."
