Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbYIPNdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbYIPNdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 09:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYIPNcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 09:32:53 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:42626 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYIPNcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 09:32:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DnFZkhPU0/Xbai5B4EF80TQJqELy5ZPB8vh9W2f4troCwCX6fg+3kk6JZHshdHGVtD
         VmGACpkybM4gV2SXPGVEa2fVIPK2tVtf28tXo+qgiASvYiZ53hxt5a4Z4VgCxnXpn2aK
         evVjj8pn/Q4f40bJ1MhgBV8C3jOdmdoTRUfNU=
Date: Tue, 16 Sep 2008 21:32:40 +0800
From: Yan Li <elliot.li.tech@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yan Li <elliot.li.tech@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, joerg.roedel@amd.com, rjmaomao@gmail.com,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, nancydreaming@gmail.com
Subject: Re: [PATCH 1/2] VMware detection support for x86 and x86-64
Message-ID: <20080916133239.GA17456@yantp.cn.ibm.com>
References: <20080221115452.GB13948@elte.hu> <20080907234510.GA24133@yantp.cn.ibm.com> <20080908140423.GG11993@elte.hu> <20080909002055.GA8573@yantp.cn.ibm.com> <48C5C47F.5040004@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C5C47F.5040004@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2008 at 05:34:07PM -0700, H. Peter Anvin wrote:
>> VMware may change the PCI ID at their will so I prefer checking the
>> DMI since it's easier.
>>
>> So if we ditched the official method we run the risk of some false
>> negatives.  But checking the DMI manufacturer would be good enough.
>>
>
> If we get false negatives that is quite frankly their problem, not ours.  
>  If nothing else, we should be able to look for a host bridge with the  
> VMWare vendor ID -- that should arguably be safer than DMI.

I found that in this situation we can't use PCI info.  My intention to
do this is to fix the false warning from
arch/x86/kernel/cpu/mtrr/main.c (around L695). When booting a VMware
guest we got:
"WARNING: strange, CPU MTRRs all blank?"

For VMware guest this warning is false, just as that for a KVM guest.

This code is from mtrr_trim_uncached_memory(), and used by
setup_arch(), which is used far before PCI is ready.

Therefore I think we can only use DMI here. Any idea?

Thanks!

-- 
Li, Yan

"Everything that is really great and inspiring is created by the
individual who can labor in freedom."
              - Albert Einstein, in Out of My Later Years (1950)
