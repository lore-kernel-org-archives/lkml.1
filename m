Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbZBOSE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbZBOSE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753447AbZBOSEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:04:50 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:63707 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbZBOSEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:04:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UdcayWuVQ1gX0StOG+VJDGw1nogg3VE8gvMPFdz9OOCAm64PKZZ8V2Nf1vsf3nIN7H
         r94zwWjfk9sr0O7Oc1fl7PGzlc/d+U2YggFmtyfWy//3khsbTbfQyO60EGGyk20XSFgD
         zuv3PegVdgHzBeo3Zm2W38/WoK3XzC5lCHL5Y=
Message-ID: <4998593D.2050300@gmail.com>
Date: Sun, 15 Feb 2009 12:04:45 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Serguei Miridonov <mirsev@cicese.mx>
CC: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx> <49973F4F.1010804@gmail.com> <200902151000.16688.mirsev@cicese.mx>
In-Reply-To: <200902151000.16688.mirsev@cicese.mx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serguei Miridonov wrote:
> Hello Robert and Jeff,
> 
> Thank you for your replies. 
> 
> On Saturday 14 February 2009, Jeff Garzik wrote:
>> Serguei Miridonov wrote:
>>> I have some problems with SATA in a new notebook PC (HP Pavilion
>>> dv5t, Intel chipset). Seagate FreeAgent Pro 1TB external drive
>>> practically can not be used with eSATA in Linux (fresh install
>>> from DVD Fedora 10, now fully updated), and yesterday I also had
>>> problem with DVD recording using internal HL-DT-ST BDDVDRW drive.
>> Some eSata fixes went into the more-recent kernels...  Can you try
>> 2.6.29-rc5?
> 
> Unfortunately, right now I can not provide a good testing bed for a 
> new kernel. I was also thinking about bad cable and returned it to the 
> store. Recording DVDs, as you understand, can not be considered for 
> testing: I don't do it on regular basis... I will be looking for a new 
> eSATA cable in a week or two, so when I have it I'll try to download 
> and build the kernel for these experiments.
> 
> On Saturday 14 February 2009, Robert Hancock wrote:
>> Serguei Miridonov wrote:
>>> Both devices work with Windows Vista. Seagate external drive even
>>> in Vista produces "parity error" messages in Windows event log
>>> but OS is somehow recovering from these errors and continues to
>>> use the drive with slight slowdown (average speed varies between
>>> 60 and 110 MB/s). Of course, it could be cable/Seagate issue, but
>>> again - Vista can handle this.
>> There are a lot of issues with eSATA drives and cabling. As Jeff
>> mentioned, there are some changes in 2.6.29-rc that may improve the
>> behavior, but the root cause here is a hardware issue (you should
>> not expect very good behavior in Vista either with those errors).
> 
> I agree with you completely. Nevertheless, something like 10 errors 
> per 2GB transfer can not be the reason to give up. Vista, at least, 
> recovers and continues the data transfer. Linux simply can not return 
> the interface or connected device into operating mode. Do you think it 
> is normal?

Could be that Linux is being a bit more aggressive on error handling. In 
your case, it looks like an error occurred, triggering a hard reset of 
the device, and the controller seemed unable to talk to the device 
afterwards. If the command had just been retried, maybe it would have 
worked better. However, doing that in general can cause issues since you 
don't know what the state of the link may be..

> 
>> As far as the DVD burning issue, it's hard to say for sure. It
>> looks like a write command was timing out. Could be due to your
>> drive not working well with that type of media.
> 
> Well, it could be, though I did not consider Sony DVD+R as bad media. 
> My fault may be... Anyway, even if it true, why k3b (or whatever 
> backend used for recording) just can not establish connection with a 
> drive because of kernel which must keep hardware working even is there 
> were some intermittent interface errors.
> 
>>> It appears that Linux kernel has problems with
>>> error-handling/reset of SATA hardware. I have found a lot of
>>> reports regarding SATA problems: data transfer failures, CD/DVD
>>> recording, waking up from suspend to RAM, etc. Aren't they all
>>> related? Can Linux SATA chipsets drivers
>> Not related at all, mostly.. though a lot of people seem to think
>> they are. Often times people think problems are related because the
>> error messages seem similar, and even the same error can be
>> triggered by numerous different problems, often not the fault of
>> the kernel.
> 
> I'm not talking now about errors triggered by the kernel due to some 
> bugs. What I see in the logs, this is the kernel fault to recover from 
> errors, not causing it. I hope that this is fixed already in newer 
> kernels, though I could not find such information in changelogs.
> 
> I could be wrong, of course, but it seems to me that if kernel can 
> really reset the interface and return it and connected devices to 
> operating mode, then most of issues mentioned above may become not so 
> critical and people could live with them until root cause is fixed 
> properly.
> 
> May be resetting the interface will not help is all cases if a device 
> is left in some screwed up state due to earlier poor error handling... 
> Well, this is another issue which can be device-vendor-dependent... 
> However, regarding external Seagate drive, Vista does not have any 
> special driver to handle its errors, it just works...

See above..
