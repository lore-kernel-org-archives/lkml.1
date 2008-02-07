Return-Path: <linux-kernel-owner+w=401wt.eu-S935495AbYBGWkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935495AbYBGWkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758273AbYBGWjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:39:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:18314 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012AbYBGWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:39:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=fmVE/6NYUPnAn1TRu+K5umc45K8lUL7Jh8iuLMBP4OrsFX5A4NOSubxikY+3uYBjv1ziRkpcF0voQAno0Zv9qnMCEGm1RxxLLkGOZuArcWX2V2TSYYg9eeTZuxJ96i3rLEc7ydsVA/C26xdcbwPIhFWCQN0OvdvBojVtRGyDeLI=
Message-ID: <47AB88AF.7090403@gmail.com>
Date: Thu, 07 Feb 2008 23:39:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
References: <47AB6552.7040503@gmail.com> <20080207223148.D0757DD807E@mail15-dub.bigfish.com>
In-Reply-To: <20080207223148.D0757DD807E@mail15-dub.bigfish.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2008 11:31 PM, Stephen Neuendorffer wrote:
>> Few comments I have:
>> - release f_op retval is silently ignored, I guess you will get your
> device into
>> undefined state when the first function fails (esp. when you interrupt
> the sem)
> 
> Hmm..  hadn't realized that.  I'm open to suggestions on how to do this
> better.  The real reason why the synchronization is there is to make
> sure that only one client is using the device at a time, using the
> is_open flag.

just mutex_lock(); that need not be interrupted.

>> - semaphores are deprecated
>> - class_device_create is deprecated
> 
> What is preferred?

device_create(); and pass the struct device as a parent when you are at it. 
Otherwise it will be in /sys/*/virtual/* I suppose.

>> - don't understand this:
>>                  memcpy(kbuf, drvdata->read_buffer, bytes_remaining);
>>                  drvdata->read_buffer_in_use = bytes_remaining;
>>                  free_page((unsigned long)kbuf);
> 
> The physical device only generates/accepts complete words, the intention
> is to account for the possibility that a read does not read complete
> words, and to fulfill the read whenever possible.
> It's arguable that read() and write() should not accept or return
> partial words, I suppose

OK, but why are you copying anything to buffer which you free 2 lines below?
