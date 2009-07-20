Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZGTWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZGTWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZGTWZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:25:55 -0400
Received: from bizon.gios.gov.pl ([195.187.34.71]:49571 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZGTWZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:25:55 -0400
X-Greylist: delayed 1568 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jul 2009 18:25:54 EDT
Date: Mon, 20 Jul 2009 23:45:04 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: ole@bizon.gios.gov.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, Krzysztof Oledzki <olel@ans.pl>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
Message-ID: <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1144830174-2062091358-1248126305=:29729"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1144830174-2062091358-1248126305=:29729
Content-Type: TEXT/PLAIN; charset=iso-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT



On Mon, 20 Jul 2009, Linus Torvalds wrote:

>
>
> On Mon, 20 Jul 2009, Greg KH wrote:
>>
>>>> Linus Torvalds (1):
>>>>      Don't use '-fwrapv' compiler option: it's buggy in gcc-4.1.x
>>>
>>> I'm very sorry to say that but 2.6.27.27 compiled with gcc-4.2.4
>>> hangs during boot and it is caused by this fix.
>>>
>>> I extended http://bugzilla.kernel.org/show_bug.cgi?id=13012 with
>>> additional info & .config.
>>
>> Wierd.  Linus, any thoughts?  Do we need to check the version of the
>> compiler that we are using before turning that option off?
>
> Dang. That was what we hoped to avoid by not using -fwrapv - we didn't
> know which compilers were buggy, although it _looked_ like just 4.1.x (I
> have some dim memory of somebody suspecting a 4.2.x version too, but that
> may have been just a "we know it should only be needed in 4.3.x, so maybe
> we shouldn't use it in 4.2.x either").
>
> But it looks like the "buggy window" for -fno-strict-overflow is
> potentially even _larger_ than it ever was with -fwrapv. And I suspect
> that in both cases the real problem is that almost nobody ever uses either
> optimization flag, so coverage is way way smaller.
>
> For now, I suspect we need to do something like this: go back to -fwrapv
> (because it has gotten more testing), but limit it to 4.2.x and newer.
>
> However, it would be really good to figure out _why_ it breaks. It's
> probably some specific configuration issue in addition to the particular
> kernel vesion (and maybe it even needs some particular hardware to show
> the bug - ie a specific driver that triggers it or whatever).

No problem. Please let me know what should I do to help tracking this 
issue.

Best regards,

 				Krzysztof Olêdzki
---1144830174-2062091358-1248126305=:29729--
