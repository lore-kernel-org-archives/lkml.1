Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYDSADy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYDSADy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 20:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYDSADr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 20:03:47 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:27717 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYDSADq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 20:03:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=femrVXsNlNUV+bO55BPo7Dr7Szh+PZfjPxWFltsGlTwCD9/6+5BFMbfTgR/TZmT1+7q/EGFEHTHvxyEchRK1LZx/ITOBiK/bmgKjOfF6elSLPLCsbg+fjiSwp89CdeVx14CL+fNZSKC1MzzvR7iURLxrLyt521V3c/wnZnRYhI4=
Message-ID: <86802c440804181703m35ce9862u9a872ca4f6829ba9@mail.gmail.com>
Date: Fri, 18 Apr 2008 17:03:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: x86: memtest bootparam
Cc: yhlu.kernel.send@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080418163226.1d8f2a62.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181717.m3IHHicT031344@hera.kernel.org>
	 <20080418145202.c96460a2.akpm@linux-foundation.org>
	 <86802c440804181507t4baf6c4dl1a68f89d3d7ce47c@mail.gmail.com>
	 <20080418163226.1d8f2a62.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 4:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 Apr 2008 15:07:46 -0700
>  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>  > On Fri, Apr 18, 2008 at 2:52 PM, Andrew Morton
>  > <akpm@linux-foundation.org> wrote:
>  > > On Fri, 18 Apr 2008 17:17:44 GMT
>  > >  Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>  > >
>  > >  > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > >  > Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > >  > Parent:     9b967106da0357ef8b08847dce35584a04134f20
>  > >  > Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
>  > >  > AuthorDate: Fri Mar 21 18:56:19 2008 -0700
>  > >  > Committer:  Ingo Molnar <mingo@elte.hu>
>  > >  > CommitDate: Thu Apr 17 17:41:21 2008 +0200
>  > >  >
>  > >  >     x86: memtest bootparam
>  > >  >
>  > >  > ...
>  > >  >
>  > >  >
>  > >  > +     memtest=        [KNL,X86_64] Enable memtest
>  > >  > +                     Format: <integer>
>  > >  > +                     range: 0,4 : pattern number
>  > >  > +                     default : 0 <disable>
>  > >
>  > >  OK.  Did the new memtest feature get documented anywhere, btw?  I'm only
>  > >  vaguely aware of its existence.
>  >
>  > need one text file in Documentation ?
>
>  Well if there was a single CONFIG_MEMTEST then it would probably be
>  sufficent to document it all within the Kconfig help for that option.
>
>  But there isn't a CONFIG_MEMTEST.  It appears that the presence or absence
>  of the memtest feature is controlled by CONFIG_MEMTEST_BOOTPARAM which
>  makes no sense at all!
>
>
>  > >  These seem pointless.  Why not just unconditionally implement memtest=?
>  > >  All the code for that should be __init anyway so we're hardly saving
>  > >  anything here.
>  >
>  > also
>  > for big box, like 64g above, that will take a while.
>
>  So... such users shouldn't add the memtest= boot parameter?
>
>
>  I'd suggest the following:
>
>  - Add a CONFIG_MEMTEST.  No other config variable needed.
>
>  - Put all the memtest code inside #ifdef CONFIG_MEMTEST.
>
>  - As part of that memtest code, implement the memtest= boot option
>
>  - Make the memtest feature default to "off" if memtest= was not provided.
>
>
>  That's all very simple and conventional?

ok, I will produce one patch. it will be

memtest=0 ==> disable
memtest=4 ==> will run 4 test pattern

YH
