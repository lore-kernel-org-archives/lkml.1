Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbYEEOqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbYEEOqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 10:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYEEOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 10:46:22 -0400
Received: from gate.crashing.org ([63.228.1.57]:38552 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbYEEOqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 10:46:22 -0400
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Message-Id: <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080504192434.GA23752@uranus.ravnborg.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: How to link a .o with all modules
Date: Mon, 5 May 2008 09:46:08 -0500
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org> <20080504192434.GA23752@uranus.ravnborg.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4, 2008, at 2:24 PM, Sam Ravnborg wrote:

> On Sun, May 04, 2008 at 01:22:38PM -0500, Kumar Gala wrote:
>> Sam,
>>
>> We have a case in powerpc in which we want to link some library
>> routines with all module objects.  The routines are intended for
>> handling out-of-line function call register save/restore so having
>> them as EXPORT_SYMBOL() is counter productive (we do also need to  
>> link
>> the same "library" code into the kernel).
>>
>> Any suggestions on how to handle this?
>
> I assume you have the .o file build somewhere as part of the
> normal kernel build.
>
> Then you in
> arch/powerpc/Makefile adds the following assignment:
>
> LDFLAGS_MODULE += arch/powerpc/lib/my_magic_file.o
>
> kbuild will then during the modpost stage link this
> file on all modules.
> To add the same file to the kernel just include it
> in a obj-y += my_magic_file.o
>
> One trap is that my_magic_file.o needs to be built
> for a modules build too.
> I think you need to assign it to always:
>
>   always := my_magic_file.o
>
> to accomplish this.
>
> So in the end we will have:
>
> arch/powerpc/Makefile:
> LDFLAGS_MODULE += arch/powerpc/lib/my_magic_file.o
>
> arch/powerpc/lib/Makefile:
> always := my_magic_file.o
> obj-y += my_magic_file.o
>
>
> Let me know if this does address your question.

The problem is MODPOST complains about undefined symbols:

   MODPOST 24 modules
ERROR: "_restgpr_20_x" [net/key/af_key.ko] undefined!
ERROR: "_restgpr_25_x" [net/key/af_key.ko] undefined!
ERROR: "_restgpr_30_x" [net/key/af_key.ko] undefined!

...

Any ideas on that?

- k
