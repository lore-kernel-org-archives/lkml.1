Return-Path: <linux-kernel-owner+w=401wt.eu-S1753238AbYIBNfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbYIBNfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYIBNf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:35:28 -0400
Received: from mail.hauppauge.com ([167.206.143.4]:2293 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYIBNf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:35:26 -0400
Message-ID: <48BD3FCC.2030206@linuxtv.org>
Date: Tue, 02 Sep 2008 09:29:48 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Mike Isely <isely@pobox.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PULL]	http://linuxtv.org/hg/~mcisely/pvrusb2
References: <Pine.LNX.4.64.0808312020060.16986@cnc.isely.net>	<20080902061821.4df5cba4@mchehab.chehab.org> <Pine.LNX.4.64.0809020815060.16986@cnc.isely.net>
In-Reply-To: <Pine.LNX.4.64.0809020815060.16986@cnc.isely.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Isely wrote:
> On Tue, 2 Sep 2008, Mauro Carvalho Chehab wrote:
>
>   
>> On Sun, 31 Aug 2008 20:20:40 -0500 (CDT)
>> Mike Isely <isely@isely.net> wrote:
>>
>>     
>>> Mauro:
>>>
>>> Please pull from http://linuxtv.org/hg/~mcisely/pvrusb2 for:
>>>
>>> - pvrusb2: Handle USB ID 2040:2950 same as 2040:2900
>>> - pvrusb2: Add comment elaborating on direct use of swab32()
>>> - pvrusb2: Remove BKL
>>> - pvrusb2: Fail gracefully if an alien USB ID is used
>>> - pvrusb2: Implement crop support
>>> - pvrusb2: Mark crop window size change as being disruptive to the encoder
>>> - pvrusb2: Be able to programmatically retrieve a control's default value
>>> - pvrusb2: Implement default value retrieval in sysfs interface
>>> - pvrusb2: Implement cropping pass through
>>> - pvrusb2: Disable virtual IR device when not needed.
>>>
>>>  pvrusb2-ctrl.c           |   10 
>>>  pvrusb2-ctrl.h           |    2 
>>>  pvrusb2-devattr.c        |    2 
>>>  pvrusb2-hdw-internal.h   |   11 -
>>>  pvrusb2-hdw.c            |  475 +++++++++++++++++++++++++++++++++++++++++------
>>>  pvrusb2-hdw.h            |   13 +
>>>  pvrusb2-i2c-chips-v4l2.c |    7 
>>>  pvrusb2-i2c-cmd-v4l2.c   |   86 ++++++--
>>>  pvrusb2-i2c-cmd-v4l2.h   |    1 
>>>  pvrusb2-i2c-core.c       |   38 ++-
>>>  pvrusb2-sysfs.c          |   24 ++
>>>  pvrusb2-v4l2.c           |  100 +++++++++
>>>  12 files changed, 669 insertions(+), 100 deletions(-)
>>>
>>> Please note that I marked the first change (the USB ID fix) as high
>>> priority; it is trivial and an obvious right thing to do.
>>>       
>> OK.
>>
>> Please: don't do tricks like this to cheat with checkpatch.pl. The error is
>> there to point to a Coding Style violation.
>>
>> +	if (ret < 0) {
>> +		/* Keep checkpatch.pl quiet */
>> +		return ret;
>> +	}
>>
>> Except for those tricks, the patches looks sane to my eyes. Please fix and ask me to pull again.
>>     
>
> Nope.  Sorry.  If I remove the "tricks", then the coding style 
> violations will come back.  You choose.  I have said this again and 
> again and again.  Forcing this style:
>
> 	if (a)
> 		b;
>
> As opposed to the much safer
>
> 	if (a) {
> 		b;
> 	}
>
> is a huge mistake.  Both generate the same code; the second form is 
> robust against someone later inserting a printk (or some other crazy bit 
> of debugging code).  I flat out refuse to use the first form.  I adopted 
> this habit over 20 years ago for a good reason, and BS like this isn't 
> going to change it.  I will put up with the space-after-comma silliness.  
> I will NOT put up with this.
>
> Those comments do NOT violate coding style.  You cannot have it both 
> ways.  Either I remove the comments and restore the "violations" or the 
> comments stand.  That is it.  No exceptions.  I have had enough with 
> this BS.  No more.

Mauro,

There is nothing wrong with adding a /* comment */ inside an if block,
even if that comment says, " /* this is the only way to pass
checkpatch.pl */ "

I fully agree with Mike, in that it is much safer to enclose all if
blocks within brackets.

I understand that kernel codingstyle forbids single line bracketing, but
codingstyle does not forbid adding comments anywhere in the c source.

Mike added a comment, to create a compromise between kernel codingstyle
and his own.  This code comes from Mike's svn repository, where he uses
#ifdefs and various other compat code within his own build environment
to stay compatible with the v4l-dvb hg tree and the upstream kernel alike.

Mike is using brackets to ensure that all builds work properly, and to
ensure that there is no breakage when creating patches for mercurial, or
when building directly from his svn repository.

There is nothing wrong with the comments that Mike has in his code --
you should not hold up his merge request for that reason.

Not only is this another example of checkpatch.pl thwarting development
-- this is sickness INSPIRED by checkpatch.pl that is not preventing a
merge -- what insanity.

Just merge his tree, please.

Regards,
Mike Krufky
