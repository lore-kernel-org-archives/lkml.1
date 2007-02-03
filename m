Return-Path: <linux-kernel-owner+w=401wt.eu-S1751825AbXBCX2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbXBCX2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 18:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbXBCX2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 18:28:10 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:58725 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXBCX2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 18:28:09 -0500
Date: Sat, 03 Feb 2007 17:28:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: hdparm for lib_pata
In-reply-to: <45C5178A.1000501@seclark.us>
To: Stephen.Clark@seclark.us
Cc: Patrick Ale <patrick.ale@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <45C51A80.3050308@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no>
 <45C4DF2A.1070501@shaw.ca> <45C5178A.1000501@seclark.us>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Clark wrote:
>> Only some of the hdparm functionality is supported in libata, which is 
>> partially by design. Presently there's no way to override the DMA 
>> settings in libata, it starts out at the fastest supported settings 
>> and falls back if it gets too many errors of certain types.
>>
>> You shouldn't be seeing errors like this unless you have bad IDE 
>> cables or are using 40-wire cables with high UDMA modes. Can you post 
>> the output you're seeing?
>>
> Ok,
> 
> But why are we taking away the users capability to control his/her own 
> hardware. Sounds like windows.
> 
> My $.02
> Steve Clark

A lot of those hdparm commands are legacy cruft from the old drivers/ide 
setup and just aren't needed with libata. For example, I think a major 
use for the enable/disable DMA option was for screwy distro setups where 
all the IDE drivers were built modular and the IDE core would load some 
generic support for the controller, then the device-specific driver 
module would get loaded and then you'd have to switch DMA on manually 
afterwards. (The old IDE drivers never really seemed to play well with 
being built as modules, probably a big reason why Red Hat/Fedora have 
always built them into the kernel.)

Support for that ioctl could likely be added, but these days I don't 
think there's much use for it. I can't see how anybody in their right 
mind would want to disable DMA on a modern drive, and if libata turns it 
off automatically then there's likely some serious hardware or driver 
problem that will end up biting you some other way if you force it back on.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

