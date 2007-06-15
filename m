Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbXFORDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbXFORDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXFORDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:03:21 -0400
Received: from gw.goop.org ([64.81.55.164]:49596 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbXFORDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:03:19 -0400
Message-ID: <4672C658.2070108@goop.org>
Date: Fri, 15 Jun 2007 10:03:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 04/10] i386: clean up bzImage generation
References: <20070615004818.424726597@goop.org> <20070615005012.962196819@goop.org> <4672BC3E.6080308@zytor.com> <4672BF82.9050101@goop.org> <4672C383.7000304@zytor.com>
In-Reply-To: <4672C383.7000304@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>   
>> H. Peter Anvin wrote:
>>     
>>> Jeremy Fitzhardinge wrote:
>>>   
>>>       
>>>> -setup_move_size: .word  0x8000		# size to move, when setup is not
>>>> +setup_move_size: .word  _setup_size	# size to move, when setup is not
>>>>  					# loaded at 0x90000. We will move setup
>>>>  					# to 0x90000 then just before jumping
>>>>  					# into the kernel. However, only the
>>>>     
>>>>         
>>> This is WRONG and will break 2.00 protocol bootloaders, if any still
>>> exist, and quite possibly some 2.01 protocol bootloaders.  There are
>>> definitiely bootloaders in the field that rely on this implicit value.   
>>>       
>> Ah, I see.  I didn't see any documentation saying that this must be
>> 0x8000.  Or does _setup_size just have to be <= 0x8000?
>>
>>     
>
> The default for unaware bootloaders has been 0x8000 since the boot
> protocol was created, and bootloaders are known to (improperly) rely on
> it.  _setup_size does have to be <= 0x8000, but that's another issue.
>   

Hm, so the worst that could happen is that an old bootloader will
over-copy 0x8000 bytes rather than the specified amount?  How would that
break anything?

> I said it probably wouldn't hurt to drop it.  I don't believe you ever
> actually explained why you wanted it dropped.

Well, I don't specifically care for Xen; I don't really mind either way
in general.  I'll break it into a separate patch and we can handle it
that way.

    J
