Return-Path: <linux-kernel-owner+w=401wt.eu-S1759287AbYCFJyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759287AbYCFJyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:54:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYCFJy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:54:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYCFJyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:54:25 -0500
Message-ID: <47CFBF28.4060309@redhat.com>
Date: Thu, 06 Mar 2008 09:53:44 +0000
From: Andrew Haley <aph@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Aurelien Jarno <aurelien@aurel32.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Michael Matz <matz@suse.de>,
       Joe Buck <Joe.Buck@synopsys.COM>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <47CF0627.2070200@zytor.com> <47CF07FE.10200@aurel32.net>
In-Reply-To: <47CF07FE.10200@aurel32.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aurelien Jarno wrote:
> H. Peter Anvin a écrit :
>> Michael Matz wrote:
>>>
>>> On Wed, 5 Mar 2008, Aurelien Jarno wrote:
>>>
>>>>> So I think gcc at least needs an *option* to revert to the old
>>>>> behavior,
>>>>> and there's a good argument to make it the default for now, at least
>>>>> for
>>>>> x86/x86-64 on Linux.
>>>> And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0,
>>>> they have the same behaviour as Linux, that is they don't clear DF
>>>> before calling the signal handler.
>>> Sigh.  We could perhaps insert a cld for all functions which can be
>>> recognized as possible signal handlers and call other unknown or
>>> string functions.  But it's probably even faster to emit cld in front
>>> of the inline copies of mem functions again :-(
>>>
>> Well, there is a (slight) difference: you know that a called function
>> will not clobber your DF state; it's only the entry condition which is
>> imprecise.
>>
>> The best would be if this could be controlled by a flag, which we can
>> flip once kernel fixes has been around for long enough.
> 
> I have to agree there. Whatever the decision that gcc will take,
> distributions will reenable the old behaviour for some time for to allow
> upgrades from a previous version.
> 
> Providing a flag to switch the behaviour (whatever the default
> behaviour) will help a lot.

I think you've got the timescales wrong.  Anything that we do now in gcc will
take a while to percolate to the Linux distributions.  It is far quicker for
those distributions to fix their kernels as fast as possible.  By the time any
gcc fix is in the world all of this will be over.

I suppose one could apply the precautionary principle, but those systems that
don't update kernels won't update gcc either, so the solution won't work.

Andrew.

