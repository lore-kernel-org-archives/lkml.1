Return-Path: <linux-kernel-owner+w=401wt.eu-S1760309AbXGDARX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760309AbXGDARX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXGDARQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:17:16 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24671 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbXGDARP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:17:15 -0400
Date: Tue, 03 Jul 2007 18:17:04 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-reply-to: <fa.d3GOse+YbAb42uYwLymWkJiH9Fw@ifi.uio.no>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Message-id: <468AE700.7080102@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ftLWBLCc+XqdYjiuxoPg+qyuUOE@ifi.uio.no>
 <fa.Oxrm8HYXTOF4jv5LrTjEe16lCE0@ifi.uio.no>
 <fa.d3GOse+YbAb42uYwLymWkJiH9Fw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 06:21:42PM -0400, Alan Stern wrote:
>> On Tue, 3 Jul 2007, Matthew Garrett wrote:
>>> We're used to the idea of applications blocking when a resource they're 
>>> using goes away - NFS has done it forever. 
>> You persist in evading my point.  I'm not worried about applications;  
>> I'm worried about drivers.
>>
>> Let me put it explicitly: You're writing a driver.  You're working on
>> the read, write, or probe method.  You add code to check if a system
>> sleep is underway.  Suppose the answer is Yes -- what does your driver
>> do next?
> 
> Leave the process blocked and defer any i/o until after resume. Why does 
> it need to be any more complicated than that?

It gets complicated when this has to be added and TESTED in EVERY 
driver. The implied contract for drivers previously was that their 
device would not get accessed after it was suspended until it had been 
resumed first. This proposed change violates that.

I don't think this sort of handling is something that individual drivers 
should have to deal with (at least not ones that are part of a framework 
like USB, libata, etc.)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

