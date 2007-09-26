Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbXIZJ4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbXIZJ4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbXIZJ4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:56:22 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:41179 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbXIZJ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:56:21 -0400
Message-ID: <46FA2CC0.2000204@Arcor.de>
Date: Wed, 26 Sep 2007 11:56:16 +0200
From: Henry Nestler <Henry.Ne@Arcor.de>
User-Agent: Thunderbird 1.5.0.13 (X11/20070809)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: kbuild: LDFLAGS_MODULE unusable for external module builds (2.6.23-rc2)
References: <46F8D9B8.3090806@Arcor.de> <20070925192250.GA14689@uranus.ravnborg.org>
In-Reply-To: <20070925192250.GA14689@uranus.ravnborg.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

Sam Ravnborg wrote:
> Hi Henry.
> 
> On Tue, Sep 25, 2007 at 11:49:44AM +0200, Henry Nestler wrote:
>> In reference of git 114f51577724b782a30f4f5ceaee9880de93d776:
>>>    kbuild: use LDFLAGS_MODULE only for .ko links
>>>    
>>>    Sam Ravnborg pointed out that Documentation/kbuild/makefiles.txt 
>>>    already
>>>    says this is what it's for.  This patch makes the reality live up to 
>>>    the
>>>    documentation.  This fixes the problem of LDFLAGS_BUILD_ID getting 
>>>    into too
>>>    many places.
>> LDFLAGS_MODULE is not usable in module build out of kernel tree since
>> 2.6.23-rc2. LDFLAGS_$@ should use, but does never work. - Not for
>> external module builds with the option "M=..."
> 
> LDFLAGS_MODULE are reserved for architectures and modules be external
> or not should never ude LDFLAGS_MODULE.
> And LDFALGS_$@ have never been documented to work for modules - dunno
> where you have that from.
> IIRC we only use LDFALGS_$@ in the ld macro to be used by bootloaders.
> 
>> What macro should set for linker parameters of foo.o ? I'm not shure.
> Have you read:
> Documentation/kbuild/makfilefiles.txt?

Yes. This was a *very* helpfull. And many examples spokes about 
LDFLAGS_$@ there. Not directly described for modules.

>>From your description you want to add a specific set of options to
> the linker in a specific Kbuild file.
> This is what EXTRA_LDFLAGS are present to help you with.
> 
> As for the:
>> # Deal with recursive depens of libraries
> I am not sure what you mean (despite yout comprehensive description).

depens = lib1 has external dependently from lib2, and lib2 later depends 
on externals from lib1. The main problem is, how can add multiple lib.a 
to module?

> Please try if EXTRA_LDFLAGS := --start-group lib.a --end-group
> will solve your need.

isn't usable. There I have problems with dependencies. dir/lib.a would 
not build, if lib.a is not in the list "...-objs".

> I'm afraid not due to the placement of the --start-group --end-group.
> If this does not help you please give me specific examples of how
> the ld command-line should be then I can see how we tweak kbuild
> to help you.

An abstracted Makefile shows:
   obj-y := dir1/ dir2/ dir3/
   obj-m := name.ko
   name-objs = foo.o dir1/lib.a dir2/lib.a dir3/lib.a
   EXTRA_LDFLAGS := --start-group # recursive dependencies of libraries

 From short testing was seen the flags ok. The current project Makefile 
is in [1]. I will try "EXTRA_LDFLAGS := --start-group" without the 
end-group in the project tree and mail again. Thanks for your help.

[1] 
http://colinux.svn.sourceforge.net/svnroot/colinux/branches/devel/src/colinux/os/linux/kernel/module/Makefile

-- 
Henry

