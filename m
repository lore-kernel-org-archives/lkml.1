Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbZHKMsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbZHKMsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZHKMsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:48:14 -0400
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:36863 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZHKMsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:48:11 -0400
Message-ID: <4A8125AC.30400@gefanuc.com>
Date: Tue, 11 Aug 2009 09:02:52 +0100
From: Martyn Welch <martyn.welch@gefanuc.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg K-H <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> <20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com> <20090810141442.GA18456@braap.org> <20090810153127.GB23319@braap.org> <4A804D67.4080308@gefanuc.com> <20090810195048.GB3055@braap.org>
In-Reply-To: <20090810195048.GB3055@braap.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emilio G. Cota wrote:
> Martyn Welch wrote:
>   
>> If the driver writer wants a "single shot" effect, there's little  
>> overhead in creating a one item link-list and executing it. However,  
>> without support for this mode the author is stuck with single shot  
>> transfers.  If the author wants to perform scatter gather type  
>> transfers, without this functionality in the API - which is supported by  
>> all the bridges I have seen - he won't be able to easily avail himself  
>> of this functionality and get "work done".
>>     
>
> Again, he (the driver writer) should know *nothing* about that.
>
> As for the scatter-gather case, what should happen is:
>
> User:		hey, there's a buffer I want to transfer. here's
> 		a pointer and size
>   

Buffer where? On VME or PCI, where are you transferring it to? The API I 
have will allow scattered locations on VME to be copied to PCI and 
visa-versa, scattered locations on PCI to be copied to VME and 
visa-versa. Even scattered locations on VME to scattered locations on 
PCI with a bit of effort.

> VME layer:	ok, passing it to the bridge
> VME bridge:	I know I'm over PCI, so I'll get the pages
> 		from memory and map the sg list over PCI, and
> 		then will tell the bridge to perform from there.
>
> That's just a particular example, but for the user (read driver
> writer) it's much simpler this way. Doesn't need to know about
> lists or whatever.
>   

But seems to fail to provide the flexibility that I outlined above.

Martyn
> E.
>   

-- 
Martyn Welch MEng MPhil MIET (Principal Software Engineer)   T:+44(0)1327322748
GE Fanuc Intelligent Platforms Ltd,        |Registered in England and Wales
Tove Valley Business Park, Towcester,      |(3828642) at 100 Barbirolli Square,
Northants, NN12 6PF, UK T:+44(0)1327359444 |Manchester,M2 3AB  VAT:GB 927559189
