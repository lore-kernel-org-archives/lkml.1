Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZDUMrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZDUMrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 08:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDUMrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 08:47:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:32924 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZDUMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 08:47:22 -0400
Message-ID: <49EDC050.1040700@redhat.com>
Date: Tue, 21 Apr 2009 14:47:12 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com> <49ED8E6D.80005@redhat.com> <49ED9C70.5010906@redhat.com> <49EDB0E0.5060101@redhat.com> <49EDBBBF.90509@redhat.com>
In-Reply-To: <49EDBBBF.90509@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/09 14:27, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>> (1) cpuid 0x40000000, check vmm signature
>> (2) cpuid 0x40000002 -> returns # of pages (eax) and msr (ebx)
>> (3) allocate pages (normal ram)
>> (4) foreach page (wrmsr "guest physical address | pageno")
>>
>> Xen uses msr 0x40000000. Due to the msr being queried via cpuid it
>> should be possible to use another one. Modulo guest bugs of course ...
>
> Is there an interface to forget a page? (if not, how do you unload a
> driver? presumably Xen remembers the page address so it can patch it)

Not sure, have to dig into the xen code to figure.

Could be xen doesn't remember the page in the first place.  They might 
let the illegal instruction fault handler patch the opcode.  At least I 
vaguely remember some discussions about that.

Could be there isn't a interface to forgot the page.  "reboot" in xen 
land is "destroy guest, restart it".

> If you load each driver, do you run this multiple times, or does the
> first driver run this once and the others reuse the same pages?

There is one driver (xen-platform-pci) which does this once at load 
time, then provides xenish services (event channels, ...) to the actual 
frontend drivers.  So for the actual frontend drivers there isn't a big 
difference between pure-pv and pv-on-hvm.

> Sure, but later on, we may want to take advantage of kernel netback.

Agree.  But right now I have more important stuff to worry about ;)

cheers,
   Gerd

