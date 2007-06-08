Return-Path: <linux-kernel-owner+w=401wt.eu-S937938AbXFHF2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937938AbXFHF2D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 01:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935759AbXFHF1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 01:27:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:29886 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934860AbXFHF1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 01:27:54 -0400
Date: Fri, 8 Jun 2007 07:27:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch
In-Reply-To: <20070607230657.GV7266@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0706080719080.31739@fbirervta.pbzchgretzou.qr>
References: <20070605073335.GM7266@flower.upol.cz> <20070605081959.GB21991@uranus.ravnborg.org>
 <20070605133834.GO7266@flower.upol.cz> <20070605141254.GA24722@uranus.ravnborg.org>
 <20070605145759.GP7266@flower.upol.cz> <20070605151101.GQ7266@flower.upol.cz>
 <20070606174556.GS7266@flower.upol.cz> <20070606175026.GA6303@uranus.ravnborg.org>
 <20070606191426.GT7266@flower.upol.cz> <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr>
 <20070607230657.GV7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Jun 8 2007 01:06, Oleg Verych wrote:

>- empty lines in the end of file (patches can't be handled, or can? :).

Yes it can.

>Body -- is a commented sed script with shell variables for source/patch
>handling switch and compatibility with other versions of sed, not only GNU.
>If you like more tabs, then i stated in whitespace damage, just use
>"unexpand".

sed just does not cut it anymore. Perl regexes win in the long term.

>> Yes, UNIX was designed to handle fork-exec efficiently, thank God. But
>> still.
>[]
>> >    efforts to remove bashizms...
>> 
>> I prefer bashisms over using a shell [referring to original sh or ksh]
>> that can't do a sane thing.
>
>I would like to know cases. Just to try to solve them.
>
>Two from my head are:
>
>- `set pipefail' option -- not problem at all [0]
>- arrays.
>
>Arrays. Well, that depends. My option is as follows.

If you need arrays or a lot of substr magic, well, it's perhaps time to
consider a switch to a scripted language (perl, python, php, whatever comes
around). But I really meant these handy bash features:

  for i in {1..5}; do ...; done;
  if [ ]; then ...; fi;
  echo $[ math expr ];
  echo `backtick` and $(backtick with dollar-parentheses);

  The possibility to say if [ "$any" == "" ] (not having to use
  crap like [ "x$any" == "x" ].

  The possibility to say if [ -z "$any" ]

On the other hand, if you wanted to extinguish bashisms, then you'd
also need to do so for kshisms like

  if [[ ]]

>OK, to not to go offtopic, i would say here, that if that temp file on the
>tmpfs, then Linux directly helps you with its efficient memory
>management, not libc (good addition to fork/clone-execve, isn't it? ;)

And don't assume everything is a UNIX. CreateProcess() is particularly
expensive on Windows, burdening even Cygwin's fork()/exec() emulation.



	Jan
-- 
