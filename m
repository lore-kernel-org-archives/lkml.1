Return-Path: <linux-kernel-owner+w=401wt.eu-S1765020AbXJZS0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765020AbXJZS0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbXJZS0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:26:15 -0400
Received: from mail2.racsa.co.cr ([196.40.31.26]:34228 "EHLO
	barracuda6.racsa.co.cr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbXJZS0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:26:13 -0400
X-ASG-Debug-ID: 1193423162-5bc2000e0000-xx1T2L
X-Barracuda-URL: http://172.16.1.15:8000/cgi-bin/mark.cgi
Date: Fri, 26 Oct 2007 12:25:58 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-ASG-Orig-Subj: Re: Old version of lilo fails to boot 2.6.23
Subject: Re: Old version of lilo fails to boot 2.6.23
In-reply-to: <4721194F.1040202@zytor.com>
Message-id: <Pine.LNX.4.64.0710260131280.17830@bruno>
References: <Pine.LNX.4.64.0710151600090.15578@bruno>
 <20071025014746.96e5e776.akpm@linux-foundation.org>
 <47211070.4090502@zytor.com> <4721194F.1040202@zytor.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Barracuda-Connect: UNKNOWN[172.16.7.13]
X-Barracuda-Start-Time: 1193423162
X-Barracuda-Virus-Scanned: by Barracuda Spam Firewall at racsa.co.cr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 25 Oct 2007, H. Peter Anvin wrote:

> H. Peter Anvin wrote:
>> [Ancient LILO boot problem]
>> 
>> Joseph, could you try this patch on your ancient-LILO setup?
>> 
>
> Actually, please try this one instead.
>
> 	-hpa
>


This patch will work in my particular case, though it appears to violate the
rules about getting too close to the EBDA (SP=0xB000 on entry).

The boot loader is responsible for loading the kernel loader at a suitable
location in low memory, but I don't understand why the boot loader should be
involved in setting the stack at all.  If we explicitly allocate the stack
as part of the .data segment, why not just play it safe and in all cases
fully set up the stack in header.S?  This insures that the stack pointer is
not zero, is as low as possible to stay out of the EBDA, and that ss=ds;
quite irrespective of what the boot loader does.

What am I missing?


Regards,

Joseph


Please CC me directly as I am no longer subscribed to the list.
