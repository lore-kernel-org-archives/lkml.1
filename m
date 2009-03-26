Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZCZHxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZCZHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZCZHwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:52:35 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:54729 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZCZHwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:52:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C1nYSMcbXFmTUXkvMPFxEfZSIV9JXO0TLRIrKFaGIg7E2jADGA/bDyyrMUn44V+0dy
         NzwiKxnMp4UF42Pmagt1KrUmSH5s1RH+khqlEG75ukeR9p84raQQmi92VlvxqkBTafxm
         ulYqNH1MPsuo0dJhnse/FVmE/4TwHitfoGioE=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903252208440.3397@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <1238015156.2500.83.camel@ht.satnam>
	 <alpine.LFD.2.00.0903252208440.3397@localhost.localdomain>
Date: Thu, 26 Mar 2009 16:52:31 +0900
Message-ID: <49b7c2350903260052o74b1184chba7964c040fa55ce@mail.gmail.com>
Subject: Re: [Announce] 2.6.29-rt1
From: GeunSik Lim <leemgs1@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I understood statement that Thosmas explained about invalid access of
2.6.29-rt1 soruces.
In general,
We remeber rc directory (./v2.6/testing/ and release directory
(./v2.6/) certainly.

Release Version is located in http://www.kernel.org/pub/linux/kernel/v2.6/ site.
RC      Version is located in
http://www.kernel.org/pub/linux/kernel/v2.6/testing/ site.

I summarized quick howto per notice of "2.6.* rt patch" file.
fc9#> wget http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.29.tar.bz2
  (If linux version is RC[release candidate] version,
 use "wget http://www.kernel.org/pub/linux/kernel/v2.6/testing/***" command.)
fc9#> wget http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rt1.bz2
fc9#> tar xjf ./linux-2.6.29.tar.bz2
fc9#> tar xvjf ./patch-2.6.29-rt1-broken-out.tar.bz2
fc9#> cd ./linux-2.6.29
fc9#> for i in `cat ../patches/series | grep patch | grep -v "#"  `;do
echo "+++ patching $i"; patch -p1 <

../patches/$i;done
fc9#> cp ./arch/x86/configs/i386_defconfig ./.config
fc9#> make menuconfig
        ..... Below Omission .....
  	

Regards,
GeunSik Lim


2009/3/26 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 26 Mar 2009, Jaswinder Singh Rajput wrote:
>
>> On Wed, 2009-03-25 at 21:59 +0100, Thomas Gleixner wrote:
>> > We are pleased to announce the next update to our new preempt-rt
>> > series.
>> >
>> >      - port forward to 2.6.29 final
>> >
>> > Download locations:
>> >
>> >     http://rt.et.redhat.com/download/
>> >     http://www.kernel.org/pub/linux/kernel/projects/rt/
>> >
>> > Information on the RT patch can be found at:
>> >
>> >     http://rt.wiki.kernel.org/index.php/Main_Page
>> >
>> > to build the 2.6.29-rt1 tree, the following patches should be
>> > applied:
>> >
>> >     http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29.tar.bz2
>>
>> Is this valid ?
>
> If we remove the testing/ it should work better :)
>
>   tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
--
Regards,
GeunSik Lim
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
