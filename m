Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbYGJIUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbYGJIUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 04:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYGJIUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 04:20:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:53202 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYGJIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 04:20:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cDKSlk341JqA1QZZrJoDvp5WoKHDKyjyFAXJyNEDqffO8RFtwRJR0Qj4am0B9JtgFE
         PHbyb60/7Xh6YLrEIpNTJXkhuSWer5AaEEII/MNXSjAgwNwTFzViDWeiw4smlTuS/My/
         v6a9+10KvnrTz4p+QyS8ahoqJ3TGstJzFKa54=
Message-ID: <4875C5C2.6010703@gmail.com>
Date: Thu, 10 Jul 2008 10:18:10 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Matthias Schniedermeyer <ms@citd.de>
CC: "Shaun R." <mailinglists@unix-scripts.com>, linux-kernel@vger.kernel.org
Subject: Re: 64bit kernel, 32bit OS?
References: <g53keq$vq1$1@ger.gmane.org> <20080710072037.GA10883@citd.de>
In-Reply-To: <20080710072037.GA10883@citd.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2008 09:20 AM, Matthias Schniedermeyer wrote:
> On 09.07.2008 17:16, Shaun R. wrote:
>> If i where to run a 32bit OS on a 64bit kernel would there be any 
>> problems with that?  I'm not trying to convert the OS to 64bit, just 
>> would rather not have to build multiple kernels if i dont have too.  I'm 
>> talking x86_32 and x86_64 btw too.
> 
> I guess you mean 32bit userspace with a 64bit kernel.
> 
> And that's no problem as long as "CONFIG_IA32_EMULATION" is set
> The option is in the menu: Executable file formats / Emulations
> and is called: IA32 Emulation

Just my $.02. I do this configuration for years on some machines.

The only problem I've ever met is that some drivers are broken to support this 
configuration, some ioctls or mmap structures simply binary differs on 32 and 
64-bit (due to different alignment and members size) and the driver can't cope 
with that -- doesn't define ioctls independently on arch or let the structures 
unaligned.

So make sure you won't use any proprietary blob which can't handle this (e.g. 
nvidia is OK).
