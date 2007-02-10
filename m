Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbXBJBu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbXBJBu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXBJBu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:50:59 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:31360 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXBJBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:50:58 -0500
Date: Fri, 09 Feb 2007 19:50:46 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: NAK new drivers without proper power management?
In-reply-to: <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, nigel@nigel.suspend2.net
Message-id: <45CD24F6.8090107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
 <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
 <fa.DuG12yQo+RR4jIjJTnoOwtKM0Ao@ifi.uio.no>
 <fa.Jy0FJQtASvVEpsy8Q96uoHtyEVA@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Nigel Cunningham wrote:
>> Hi.
>>
>> On Fri, 2007-02-09 at 23:17 +0100, Arjan van de Ven wrote:
>>> On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
>>>> Hi.
>>>>
>>>> I don't think this is already done (feel free to correct me if I'm
>>>> wrong)..
>>>>
>>>> Can we start to NAK new drivers that don't have proper power management
>>>> implemented? There really is no excuse for writing a new driver and not
>>>> putting .suspend and .resume methods in anymore, is there?
>>>
>>> to a large degree, a device driver that doesn't suspend is better than
>>> no device driver at all, right?
>>
>> I'm not sure it is. It only makes more work for everyone else: We have
>> to help people figure out what causes their computer to fail to resume
>> (which can take quite a while), then get them them complain to driver
>> author, and the driver author has to submit patches to fix it.
>>
>> All of this is avoided if they'll just do it right in the first place.
> 
> A lot of a lot of things could have been avoided, if they just did it 
> right the first time.
> 
> I think it's more valuable to users to get a basic network driver that 
> pings or a basic ATA driver that reads/writes, than peripheral issues 
> like suspend/resume.
> 
> Certainly we should ask for it, but it shouldn't be a merge-stopper.
> 
>     Jeff

I would disagree that it's a peripheral issue, it's pretty core these 
days, at least for any hardware that you can stuff in a laptop (though a 
fair number of desktops get suspended and resumed these days too). One 
driver on a system which doesn't suspend or resume properly can ruin the 
entire process, causing a ton of user frustration. Certainly I would 
consider a driver without suspend/resume support to be incomplete.

The trouble with deferring adding this support is that it's a lot harder 
to add this support in after the fact than if it was considered during 
the original driver development.

I would be in favor of not merging drivers lacking suspend unless 
there's a very good reason they're lacking it.

It also kind of bothers me that if a driver has no suspend/resume 
functions, and you suspend and resume the system, we don't complain 
about it even though there's a very good chance that device is not going 
to function properly. How about something in dmesg like:

Warning: driver for device XXXX has no suspend or resume support.
Device may not function properly after resume.

so that users know who to complain to. Maybe there are some devices that 
truly don't need any handling for suspend, but if so I suspect the 
number of those is small enough that adding empty functions would be a 
good-enough solution.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

