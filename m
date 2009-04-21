Return-Path: <linux-kernel-owner+w=401wt.eu-S1755375AbZDUQBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbZDUQBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbZDUQBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:01:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57638 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZDUQBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:01:05 -0400
Message-ID: <49EDEDAD.20900@redhat.com>
Date: Tue, 21 Apr 2009 18:00:45 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Huang Ying <ying.huang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Xenner design and kvm msr handling
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>	 <49DE195D.1020303@redhat.com>	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>	 <49E08762.1010206@redhat.com> <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com> <49E337D7.5050502@redhat.com> <49EA515C.9000507@codemonkey.ws> <49EAE1F6.9050205@redhat.com> <49EC29D1.8040407@redhat.com> <49EC3198.9070902@redhat.com> <49EC3987.2040001@redhat.com> <49EC3AD6.3090905@redhat.com> <49EC5B2A.9080403@redhat.com> <49EC5C3A.6020108@redhat.com> <49EC68A7.8080403@redhat.com> <49EC6DEE.4070703@redhat.com> <49EC7797.7060004@redhat.com> <49EC7C5F.2000006@redhat.com> <49ED8E6D.80005@redhat.com> <49ED9C70.5010906@redhat.com> <49EDB0E0.5060101@redhat.com> <49EDBBBF.90509@redhat.com> <49EDC050.1040700@redhat.com> <49EDCB1D.1010301@redhat.com>
In-Reply-To: <49EDCB1D.1010301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/09 15:33, Avi Kivity wrote:
> Gerd Hoffmann wrote:
>> Not sure, have to dig into the xen code to figure.
>>
>> Could be xen doesn't remember the page in the first place. They might
>> let the illegal instruction fault handler patch the opcode. At least I
>> vaguely remember some discussions about that.

Xen does a simple msr-triggered memcpy() as well, without keeping track 
of the page.  On a quick glimpse I can't find a opcode patching place 
either.  Hmm.

>> Could be there isn't a interface to forgot the page. "reboot" in xen
>> land is "destroy guest, restart it".
>
> How do you unload a driver then?

The linux module (xen-platform-pci) has no module_exit() ...

cheers,
   Gerd
