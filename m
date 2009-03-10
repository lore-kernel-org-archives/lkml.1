Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZCJNLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZCJNLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZCJNLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:11:21 -0400
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:62904 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZCJNLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:11:20 -0400
Date: Tue, 10 Mar 2009 09:11:17 -0400 (EDT)
From: Steve Rottinger <steve@www.rottinger.net>
Subject: Re: Direct transfer between SCSI and PCI
In-reply-to: <49B5A212.1040300@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Steve Rottinger <steve@www.rottinger.net>, linux-kernel@vger.kernel.org
Message-id: <52936.12.35.250.145.1236690677.squirrel@www.rottinger.net>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Importance: Normal
X-Priority: 3 (Normal)
References: <36600.12.35.250.145.1236605376.squirrel@www.rottinger.net>
 <49B5A212.1040300@gmail.com>
User-Agent: SquirrelMail/1.4.8-1.fc5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI device would use it's DMA controller to copy the data, just as it
would if the buffer was in the processor's RAM.  If I understand
correctly, if I open up the SCSI device using the O_DIRECT option, the
driver will DMA directly to/from the user buffer specified by the
write()/read() functions. Instead, of that buffer being an address
pointing to the processors RAM, I would like that buffer to point to the
PCI address of the buffer on my PCI device. Currently, when I try this on
an mmapped buffer to my PCI device, the write() routine returns a "Bad
address" error.

-Steve


> On 9.3.2009 14:29, Steve Rottinger wrote:
>>As part
>> of my project, I need to be able to directly transfer data from a large
>> buffer that resides on
>> a custom PCI communications device to a SCSI disk without going through
>> the CPU's main
>> memory.  Initially, it seemed like opening up the raw SCSI device in
>> O_DIRECT mode would
>> be the perfect solution.  However, through some experimentation, and
>> reading some posts from
>> a few years back, it appears that O_DIRECT only works on buffer's that
>> reside in processor's
>> main memory.   Does anyone have any suggestions as to how to get this to
>> work?
>
> How would you want your scsi device to get the data? I suppose they are
> stored somewhere on the PCI device memory connected to its local bus or
> alike. At best it can be visible as a PCI bar but I doubt it is. As you
> described it here, there is no way, how would the SCSI device see the
> data.
>
> Or do you want to move the data from the PCI device via DMA implemented
> in it directly to the SCSI device? How would you do this? I guess SCSI
> devices do standard S/G DMA so that they read data from host memory by
> themselves.
>
> Maybe if you elaborate on what exactly do you mean by the idea?
>


