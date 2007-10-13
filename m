Return-Path: <linux-kernel-owner+w=401wt.eu-S932895AbXJMSLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbXJMSLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 14:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760536AbXJMSLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 14:11:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:30455 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925AbXJMSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 14:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PjOVCZUyt+7Ws88Z/tCUXeYeDpfmwrl/VAwBk78qnw5OVULzda2iKMlHY7btK+lIgbyzwKTMPcp0C7E+N0VT96YUt5F0J8SBGJxakdi/votlHPy0iIQ2VGOCbgC1/cSMDsD8SWelsNdgEXq20BLSqBhUVwZtd2PDJDoGbQy6uGg=
Message-ID: <471109A3.6020500@googlemail.com>
Date: Sat, 13 Oct 2007 20:08:35 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-mm1
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>	<4710FC91.6030806@googlemail.com> <20071013110103.ae4dd2da.akpm@linux-foundation.org>
In-Reply-To: <20071013110103.ae4dd2da.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Sat, 13 Oct 2007 19:12:49 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> Andrew Morton wrote:
>>
>> Hi,
>>
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
>>>
>>> - I've been largely avoiding applying anything since rc8-mm2 in an attempt
>>>   to stabilise things for the 2.6.23 merge.
>>>
>>>   But that didn't stop all the subsystem maintainers from going nuts, with
>>>   the usual accuracy.  We're up to a 37MB diff now, but it seems to be working
>>>   a bit better.
>> Works a bit better right :) At least it boots here but I have a strange problem with it.
>>
>> It seems 2.6.23-mm1 kills off java. Every program needs java here does not work anymore telling
>> 'my java' installation is incorrect. Also I noticed firefox is acting weird as well thunderbird.
>> Gtk apps just random freeze and need be killed with -11.
>>
>> Running 'java -version' manually returns nothing , 'java -jar some.jar' does nothing as well. ( not even a error or anything else )
>>
>> ( I've also tested sun's java 1.5 and 1.6 and openjre as well all with same result )
> 
> We have a screwup in thread handling which might have caused this.
> 
>> I only have a WARNING in my dmesg but i don't think this is related to this :
>>
>> Oct 13 01:44:52 lara [10722.146448] WARNING: at fs/namespace.c:586 __mntput()
>> Oct 13 01:44:52 lara [10722.146478]  [<c0167cb2>] mntput_no_expire+0x5d/0xab
>> Oct 13 01:44:52 lara [10722.146503]  [<c01683d1>] sys_umount+0x1f8/0x202
>> Oct 13 01:44:52 lara [10722.146511]  [<c010f368>] check_pgt_cache+0x13/0x15
>> Oct 13 01:44:52 lara [10722.146529]  [<c0158cd0>] sys_stat64+0xf/0x23
>> Oct 13 01:44:52 lara [10722.146549]  [<c0147a9c>] remove_vma+0x31/0x36
>> Oct 13 01:44:52 lara [10722.146574]  [<c010fbf6>] do_page_fault+0x180/0x4ea
>> Oct 13 01:44:52 lara [10722.146600]  [<c01683e6>] sys_oldumount+0xb/0xe
>> Oct 13 01:44:52 lara [10722.146614]  [<c010258e>] sysenter_past_esp+0x5f/0x85
>> Oct 13 01:44:52 lara [10722.146639]  [<c02e0000>] xfrm_tmpl_resolve+0x2bd/0x37b
>> Oct 13 01:44:52 lara [10722.146656]  =======================
> 
> I guess that's the r-o-bind-mounts stuff.
> 
>> I also noticed some programs like vlc segfaults :
>>
>> vlc[20506]: segfault at 01950000 eip 01950000 esp b4876368 error 4
>>
>> Booting 2.6.23 makes all these go away.
>>
>> I don't have anything else in my logs. Any idea what patches could cause this problem(s) ?
>>
>> Config can be found there -> http://194.231.229.228/2.6.23-mm1-config
> 
> what is vlc?

Media player -> http://www.videolan.org/vlc/


