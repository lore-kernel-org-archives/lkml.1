Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbYDRWIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbYDRWIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYDRWH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:07:58 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:19084 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYDRWH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kg9efo93tFPsqwQsKthphj3C0xH2sM68qaWJI/CogwZzxMiO9aKAk1sbgukd5Hu/QtjtYpB6ZaBMd6/H/LrUvcKArRG/W7lYshteHQQruXlpD2qW+3WKbmkvi3Gi1a3I9e4VcF6uiabi0b2KQ2W1IewDSz3xIWiMcDVIcoqaG54=
Message-ID: <86802c440804181507t4baf6c4dl1a68f89d3d7ce47c@mail.gmail.com>
Date: Fri, 18 Apr 2008 15:07:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: x86: memtest bootparam
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080418145202.c96460a2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181717.m3IHHicT031344@hera.kernel.org>
	 <20080418145202.c96460a2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 2:52 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 18 Apr 2008 17:17:44 GMT
>  Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>
>  > Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > Commit:     c64df70793a9c344874eb4af19f85e0662d2d3ee
>  > Parent:     9b967106da0357ef8b08847dce35584a04134f20
>  > Author:     Yinghai Lu <yhlu.kernel.send@gmail.com>
>  > AuthorDate: Fri Mar 21 18:56:19 2008 -0700
>  > Committer:  Ingo Molnar <mingo@elte.hu>
>  > CommitDate: Thu Apr 17 17:41:21 2008 +0200
>  >
>  >     x86: memtest bootparam
>  >
>  > ...
>  >
>  >
>  > +     memtest=        [KNL,X86_64] Enable memtest
>  > +                     Format: <integer>
>  > +                     range: 0,4 : pattern number
>  > +                     default : 0 <disable>
>
>  OK.  Did the new memtest feature get documented anywhere, btw?  I'm only
>  vaguely aware of its existence.

need one text file in Documentation ?

>
>  >
>  > +config MEMTEST_BOOTPARAM
>  > +     bool "Memtest boot parameter"
>  > +     depends on X86_64
>  > +     default y
>  > +     help
>  > +       This option adds a kernel parameter 'memtest', which allows memtest
>  > +       to be disabled at boot.  If this option is selected, memtest
>  > +       functionality can be disabled with memtest=0 on the kernel
>  > +       command line.  The purpose of this option is to allow a single
>  > +       kernel image to be distributed with memtest built in, but not
>  > +       necessarily enabled.
>  > +
>  > +       If you are unsure how to answer this question, answer Y.
>  > +
>  > +config MEMTEST_BOOTPARAM_VALUE
>  > +     int "Memtest boot parameter default value (0-4)"
>  > +     depends on MEMTEST_BOOTPARAM
>  > +     range 0 4
>  > +     default 0
>  > +     help
>  > +       This option sets the default value for the kernel parameter
>  > +       'memtest', which allows memtest to be disabled at boot.  If this
>  > +       option is set to 0 (zero), the memtest kernel parameter will
>  > +       default to 0, disabling memtest at bootup.  If this option is
>  > +       set to 4, the memtest kernel parameter will default to 4,
>  > +       enabling memtest at bootup, and use that as pattern number.
>  > +
>  > +       If you are unsure how to answer this question, answer 0.
>
>  These seem pointless.  Why not just unconditionally implement memtest=?
>  All the code for that should be __init anyway so we're hardly saving
>  anything here.

also
for big box, like 64g above, that will take a while.

YH
