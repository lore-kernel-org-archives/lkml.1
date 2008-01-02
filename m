Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYABT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYABT72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYABT7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:59:19 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:60098 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYABT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:59:18 -0500
Message-ID: <477BED13.4060403@grupopie.com>
Date: Wed, 02 Jan 2008 19:59:15 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Xiaofan Chen <xiaofanc@gmail.com>
CC: mgross <640e9920@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] libusb / in-kernel usb driver criteria (was: USB driver
 for talking to the Microchip PIC18 boot loader)
References: <20071229193409.GA20188@mgross-t43>	 <Pine.LNX.4.44L0.0712291714041.26261-100000@netrider.rowland.org>	 <20071230035349.GA4741@mgross-t43> <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com>
In-Reply-To: <a276da400712292052h5808c33apd5269e773edfb592@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaofan Chen wrote:
> On Dec 30, 2007 11:53 AM, mgross <640e9920@gmail.com> wrote:
>> [...]
>> What is the linux-usb policies on new drivers that could be
>> implemented in user space?  When does a kernel driver make sense over
>> a libusb one?
> 
> That would be interesting to know.

I myself have been faced with this question before, and I think we 
should try to clarify this by adding a document with some guidelines to 
Documentation/usb.

So, to get the ball rolling, here are some factors that IMHO help decide 
in which side to implement a driver:

  - if the driver ties a hardware device to an existing in-kernel 
interface (network, block, serial, bluetooth, video4linux, etc.), it 
should probably be implemented in-kernel.

  - on the other hand, if the driver doesn't use an existing kernel 
interface and creates a new user-visible interface that is going to be 
used by a single userspace application, it should probably be done in 
userspace.

  - if it is going to be used by several applications it could still be 
implemented as a library, but it starts moving into the gray area.

  - performance might be a reason to move to kernel space, but I don't 
think it matters for transfer rates below 10Mbytes/sec or so.

Anyway, this is just MHO, so feel free to discuss this further. I'm 
simply volunteering to sum up this thread into a patch to add a 
Documentation/usb/userspace_drivers.txt (or something like that), so 
that we can help future developers decide where to write their drivers.

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
