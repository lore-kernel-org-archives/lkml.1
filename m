Return-Path: <linux-kernel-owner+w=401wt.eu-S1757026AbXIINEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026AbXIINEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 09:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754989AbXIINEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 09:04:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:26344 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbXIINEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 09:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=OdTSWQiC7VmRgQ4aCSoP4oqx1ZUyBeTj5tH4IWUWdqH6vW2/3XiwnlB8H+2wjlhZW3E1J1tNa7l7PQ/Z1SCiyfAe1qoKgEEfPivg4Hgxy0XHvD+psKXqbCXWFtNQBrreZk4xz7o1QitIqdF+ZuQfHE0Ffzoadm8+v5zbAizudcY=
Message-ID: <46E3EF49.90004@gmail.com>
Date: Sun, 09 Sep 2007 15:04:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       airlied@linux.ie
Subject: Re: X freezes kernel during exit [Re: 2.6.23-rc3-mm1]
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>	<46D17A7A.70609@gmail.com>	<46D409FC.1070305@gmail.com>	<46E3DCB8.5010709@gmail.com> <20070909054751.cbb27081.akpm@linux-foundation.org>
In-Reply-To: <20070909054751.cbb27081.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Removed gareth@valinux.com (dead e-mail)

On 09/09/2007 02:47 PM, Andrew Morton wrote:
> On Sun, 09 Sep 2007 13:44:56 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 08/28/2007 01:41 PM, Jiri Slaby wrote:
>>> Does this went through to your boxes? Any progress, clue, idea?
>>>
>>> Jiri Slaby napsal(a):
>>>> Andrew Morton napsal(a):
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
>>>> Hi,
>>>>
>>>> I've found a regression against 2.6.23-rc2-mm2. X server shutdown freezes
>>>> (untainted) kernel hardly. Nothing on netconsole, X output follows:

--------------------------------^^^

sorry, both netconsole and my usb devices (including my keyboard -- no numlock
led switch) are dead. The trace I've taken appears on the screen after a while.

>>>> X Window System Version 1.3.0
>>>> Release Date: 19 April 2007
>>>> X Protocol Version 11, Revision 0, Release 1.3
>>>> Build Operating System: Fedora Core 7 Red Hat, Inc.
>>>> Current Operating System: Linux bellona 2.6.23-rc3-mm1 #315 SMP Wed Aug 22
[...]
>>>> (**) RADEON(0): RADEONDRICloseScreen
>>>>
>>>>
>>>>
>>>> the only difference is, that 2.6.23-rc2-mm2 writes further
>>>>
>>>> FreeFontPath: FPE "/usr/share/X11/fonts/misc:unscaled" refcount is 2, should be
>>>> 1; fixing.
>>>>
>>>> and exits succesfully (note that these messages are taken on remote host, X
>>>> runned remotely).
>>>>
>>>> Both vesa and radeon + Option "NoAccel" "true" works obviously fine.
>> Also intel on integrated i915 causes this (NoAccell has no effect in this case).
>> Note that also 2.6.23-rc4-mm1 is affected by this behaviour.
>> I have a trace for you:
>> http://www.fi.muni.cz/~xslaby/sklad/panics/x-freeze.png
>> (this is the only what I'm able to grab so far)
>>
> 
> afacit everything on that call trace is good.  I guess it's possible that
> one of the higher-level loops has gone infinite (eg, the one in
> agp_remove_controller()).

There is no loop in this function. Anyway, going to track this whole issue down.
Hold on.

> Are you able to get netconsole working, and run sysrq-P and sysrq-T
> ten or so times, see if it's always stuck in the same place on the
> same CPU?

thanks so far,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
