Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZCFWU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZCFWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZCFWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:20:11 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41728
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbZCFWUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:20:10 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Fix ARCH=um segfault on x86-64.
Date: Fri, 6 Mar 2009 16:20:04 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; x86_64; ; )
Cc: =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200903060042.19084.rob@landley.net> <20090306084848.GO22605@hack.private> <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com>
In-Reply-To: <10f740e80903060150p565e9703u81d4fe47cb599ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903061620.05990.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009 03:50:38 Geert Uytterhoeven wrote:
> On Fri, Mar 6, 2009 at 09:48, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> > On Fri, Mar 06, 2009 at 12:42:14AM -0600, Rob Landley wrote:
> >>Apparently, nobody other than me has ever attempted to use User Mode
> >> Linux built from 2.6.28 on x86-64, because it doesn't work.  It still
> >> doesn't work in current git.  I complained about it not working back in
> >> January:
> >>
> >>http://sourceforge.net/mailarchive/forum.php?thread_name=200901130159.043
> >>89.rob%40landley.net&forum_name=user- mode-linux-devel
> >>http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00669.html
> >>
> >>And today, I bothered to track down why.
> >>
> >>This is the commit that broke it, when Peter Anvin merged x86 and x86-64
> >> for ARCH=um: http://kernel.org/hg/linux-2.6/rev/117978
> >>
> >>Here's a patch that fixes it for me:
> >
> > Thanks, Bob!
>
> I've just did a build of plain v2.6.28 on amd64 aka x86-64. The
> resulting image ran fine.
>
> I attached my .config.

Which contains:
CONFIG_3_LEVEL_PGTABLES=y

So the question is, why is your config saving that value, and mine isn't?

Ah, I found it.  You enabled CONFIG_EXPERIMENTAL, and I didn't.  That's the 
difference.

Ok, CONFIG_EXPERIMENTAL is required in order for UML to initialize its memory 
management.  That makes a bit more sense why other people haven't seen this...

Rob
