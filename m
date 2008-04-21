Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbYDUXCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbYDUXCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYDUXCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:02:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:49819 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYDUXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CAC89QXZR6K0T89bCPmvIjKZVpUBKOQb56tWoJSV4zrH4It3WhpOUNXKKc2s/DkuXy/Jw40TIGU8qZyBbOtE10PSG4azLd0EHoq+/acO737lVl574ytZOVm9OwqHMh0ggv7LFHqYFC00OcJEbRBdMBLafY/jEzDtGU8Kvy35oRo=
Message-ID: <480D1CF1.7010300@gmail.com>
Date: Tue, 22 Apr 2008 01:02:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, Zdenek Kabelac <zdenek.kabelac@gmail.com>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <20080421.133940.52972455.davem@davemloft.net> <480D04A2.5000006@gmail.com> <480D0E14.1040306@gmail.com> <480D147C.90602@gmail.com> <20080421225452.GF9153@linux.vnet.ibm.com>
In-Reply-To: <20080421225452.GF9153@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2008 12:54 AM, Paul E. McKenney wrote:
> On Tue, Apr 22, 2008 at 12:26:04AM +0200, Jiri Slaby wrote:
>>> Having slub_debug enabled, tomorrow will be results, I guess...
>> Sorry, one more entry:
>>
>> 00000000000000f0 dentry.d_op (Zdenek, offset ? around 136)

Zdenek's is at offset 184.

>> 00f0000000000000 dentry.d_hash.next (me, offset 24)
>> ffff81f02003f16c dentry.d_name.name (me, offset 56)
>>         memory ORed by 000000f000000000
>> fffff0002004c1b0 file.f_mapping (me, offset 176)
>>         memory hole, it was something like
>>         (ffff81002004c1b0 & ~00000f0000000000) | 0000f00000000000?
>> ffffffffffffffff dentry.d_hash.next (Rafael, offset ? around 24)
>>         -1, ~0ULL
> 
> Are these running with CONFIG_PREEMPT_RCU?  Grasping at straws, but
> there are a couple of patches that need to move from -rt to mainline,
> but mostly related to SELinux.  So if both PREEMPT_RCU and SELinux
> were in use, we might be missing "rcu-various-fixups.patch" from:

$ grep RCU .config
CONFIG_CLASSIC_RCU=y
# CONFIG_RCU_TORTURE_TEST is not set
$ grep SECU .config
# CONFIG_EXT4DEV_FS_SECURITY is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set

I guess not.

BTW the corruption I mentioned earlier was char 'ð' and it's ('p' | 0xf0) in 
latin2. I think it was set_ðending_irq IIRC. Whatever, it won't help us.
