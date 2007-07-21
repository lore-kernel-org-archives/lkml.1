Return-Path: <linux-kernel-owner+w=401wt.eu-S937340AbXGUI1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937340AbXGUI1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 04:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbXGUI1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 04:27:34 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:26690 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbXGUI1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 04:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d7hwtaGEIyQQcCbenFGd7xoS/88sAQ/8brPzXTlSlif7/YeM4MWJokv44fG+Uvxtdrt1rixuAxid++ezFd8v0NvOsCnC/XOWP6ZJIhEdKis60M9CRE8MgsYzR4t0Sc0z4L3NNGYgau7+tlbu49ybx6GVoU+qI3g86ZnFskuuF9k=
Message-ID: <8bd0f97a0707210127m565f9b2cnc7a8a203f671e948@mail.gmail.com>
Date: Sat, 21 Jul 2007 04:27:31 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: [kbuild-devel] [PATCH 25/33] kbuild: use POSIX BRE in headers install target
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <E1ICAEU-0005an-5F@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11846813423231-git-send-email-sam@ravnborg.org>
	 <1184681344594-git-send-email-sam@ravnborg.org>
	 <11846813444176-git-send-email-sam@ravnborg.org>
	 <11846813443187-git-send-email-sam@ravnborg.org>
	 <1184681344985-git-send-email-sam@ravnborg.org>
	 <11846813442810-git-send-email-sam@ravnborg.org>
	 <118468134441-git-send-email-sam@ravnborg.org>
	 <11846813441741-git-send-email-sam@ravnborg.org>
	 <1184681344376-git-send-email-sam@ravnborg.org>
	 <E1ICAEU-0005an-5F@flower>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> * Date: Tue, 17 Jul 2007 16:08:54 +0200
> >
> > From: Mike Frysinger <vapier@gentoo.org>
> >
> > The sed expression used at the moment in scripts/Makefile.headersinst
> > relies on the (handy) GNU extension where you can escape ERE's in an
> > otherwise BRE without using the GNU -r option.  The following patch
> > replaces this "\+" usage with a functionally equivalent POSIX BRE compliant
> > "\{1,\}".
>
> Matching at least one occurrence, right?

that is the definition of both + and \{1,\}

> >  # Eliminate the contents of (and inclusions of) compiler.h
>
> OK, that means annotations and non ANSI 'inline' thing. Lets see.
>
> >  HDRSED  := sed       -e "s/ inline / __inline__ /g" \
> []
> > -             -e "s/[[:space:]]__attribute_const__[[:space:]]\+/\ /g" \
>
> * [[:space:]] are more than tab and space isspace(3), is it more
>   effective to use [[:blank:]] instead?

if you want to make some micro optimization in the build install step,
sure ... but functionally, the difference is irrelevant considering
sed operates only on individual lines

> > +             -e
> > "s/[[:space:]]__user[[:space:]]\{1,\}
>
> substitute one or more ' __user '
>
> > / /g" \
>
> with ' ', everywhere (flag 'g'). So, is it really needed that '\{' thing?

no, there is no grouping marker anywhere, so the match always applies
to just the whitespace

> > +             -e "s/(__user[[:space:]]\{1,\}/ (/g" \
> > +             -e "s/[[:space:]]__force[[:space:]]\{1,\}/ /g" \
> > +             -e "s/(__force[[:space:]]\{1,\}/ (/g" \
> > +             -e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" \
> > +             -e "s/(__iomem[[:space:]]\{1,\}/ (/g" \
> > +             -e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" \
> >               -e "s/[[:space:]]__attribute_const__$$//" \
>
> Is it allowed to use identifiers like '__attribute_const__foo' or
> __attribute_const__[anything]? If it's not, last line is useless also.

a question that i think is really only relevant if it actually occurs
in the source code

> >               -e "/^\#include <linux\/compiler.h>/d"
> whitespace is allowed   ^ here and is used for better readability
> sometimes.

so post a patch for inclusion ... not that it's been an actual problem
[yet] though
-mike
