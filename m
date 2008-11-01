Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYKATuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYKATuc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYKATuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:50:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:57800 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbYKATuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=DsZr3xb17REXPxSbH8CSIwBH60aXjouj9YlJU8z1oACLprxiZs3gpK/8iWwYB9uqtp
         vgL4+ciU3IVEwYVqMLHm/X/v3+9eM5IErZ/wV4ofMFT0cGEO6V2c18fYcFN78xN2x/mA
         OoKi1rzjckaK1tkxADfzSm0wziVSLYBceRdaE=
Message-ID: <86802c440811011250g662b8c4di31f2e391c910954e@mail.gmail.com>
Date: Sat, 1 Nov 2008 12:50:20 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Robert Hancock" <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
	 <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
	 <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
	 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
	 <20081031100040.1f0cf34f@bike.lwn.net>
	 <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
	 <20081031105105.092ebad3@bike.lwn.net>
	 <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
	 <20081101090154.3d014f57@bike.lwn.net>
	 <alpine.LFD.2.00.0811010958230.6226@nehalem.linux-foundation.org>
X-Google-Sender-Auth: d5da2023182c25a9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 1, 2008 at 10:16 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>> e0000000-fe7fffff : reserved
>> fe800000-fe8fffff : PCI Bus 0000:01
>>  fe800000-fe8fffff : reserved
>> fe900000-fe9d9aff : reserved
>> fe9d9b00-fe9d9bff : 0000:00:1f.3
>>  fe9d9b00-fe9d9bff : reserved
>> fe9d9c00-fe9d9fff : 0000:00:1a.7
>>  fe9d9c00-fe9d9fff : reserved
>> fe9da000-fe9dafff : 0000:00:03.3
>>  fe9da000-fe9dafff : reserved
>> fe9db000-fe9dbfff : 0000:00:19.0
>>  fe9db000-fe9dbfff : reserved
>> fe9dc000-fe9dffff : 0000:00:1b.0
>>  fe9dc000-fe9dffff : reserved
>> fe9e0000-fe9fffff : 0000:00:19.0
>>  fe9e0000-fe9fffff : reserved
>> fea00000-fea7ffff : 0000:00:02.0
>>  fea00000-fea7ffff : reserved
>> fea80000-feafffff : 0000:00:02.1
>>  fea80000-feafffff : reserved
>> feb00000-febfffff : 0000:00:02.0
>>  feb00000-febfffff : reserved
>> fec00000-fed003ff : reserved
>>  fec00000-fec00fff : IOAPIC 0
>>  fed00000-fed003ff : HPET 0
>
> .. which is just really messy, but is the same e0000000-fed003ff
> "reserved" e820 entry just split and moved into each resource.
>
> I hate firmware.

Jonathan, can you try patch i sent?

http://lkml.org/lkml/2008/10/31/274
[PATCH] x86: remove PCI bar range from e820 reserved entries

Impact: clean up buggy e820 tables

so make those ranges can be claimed by drivers
acctually BIOS is not supposed to put resource in pci BAR in reserved
entries of e820.
e820 entries should only include reserved range include mmconfig,
lapic, ... and others
that are not in BARs



the magic regions like gart, mmconfig, ioapic, lapic and others who
knows, should be really reserved.

YH
