Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXA0Ga1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXA0Ga1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 01:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXA0Ga1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 01:30:27 -0500
Received: from raven.upol.cz ([158.194.120.4]:41052 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbXA0Ga0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 01:30:26 -0500
Date: Sat, 27 Jan 2007 06:38:36 +0000
To: Tim Schmielau <tim@physik3.uni-rostock.de>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@osdl.org>,
       Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: scripts/makelst: bc -> shell Re: sed _s_gnu_alternatives_ (Re: [rft] (g)awk substitution)
Message-ID: <20070127063836.GA15178@flower.upol.cz>
References: <200701151624.18033.rob@landley.net> <200701251438.03213.rob@landley.net> <20070125211802.GC10907@flower.upol.cz> <200701261247.22374.rob@landley.net> <20070126201451.GA14946@flower.upol.cz> <Pine.LNX.4.63.0701270113400.4567@gockel.physik3.uni-rostock.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0701270113400.4567@gockel.physik3.uni-rostock.de>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo.

On Sat, Jan 27, 2007 at 01:18:30AM +0100, Tim Schmielau wrote:
> On Fri, 26 Jan 2007, Oleg Verych wrote:
> 
> > In Debian's version it has no `bc', while native `bc' is producing
> > crap like that:
> > ,-*- bash -*-
> > |olecom@flower:~$ printf "%u" $(( -1 )) ; echo
> > |18446744073709551615
> > |olecom@flower:~$ echo -1 | bc
> > |-1
> > |olecom@flower:~$ printf "%u" $(( 0xFF )) ; echo
> > |255
> > |olecom@flower:~$ echo FF | bc
> > |99
> > |olecom@flower:~$ echo F | bc
> > |15
> > |olecom@flower:~$
> > `-*-
> > 
> > i can't understand the result... I think linux/scripts/makelst may be
> > updated to have sh's version of address calculation ;)
> 
> No, IMHO that should not be a reason to change anything in the kernel.
> Just set ibase=16 or read the fine manual:

Thank you very much ;) Maybe i must use XSLT with 0.99 kernel, or
what?

I'm talking about patch posted here:
Message-ID: <E1H9rZ3-0002T5-Po@flower>
Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/485999>

,-*- diff snip -*-
|-    t4=`echo $t3 | gawk '{ print $1 }'`
|-    t5=`echo $t1 | gawk '{ print $1 }'`
|+    t4=`pos_param 1 $t3`
|+    t5=`pos_param 1 $t1`
5     t6=`echo $t4 - $t5 | tr a-f A-F`
6     t7=`( echo  ibase=16 ; echo $t6 ) | bc`
`-*-

I've just noticed, that things on lines 5 and 6 may be optimized.

t7=`printf "%lu" $(( 0x$t4 - 0x$t5 ))`

No tr, no bc, no pipes -- magic!
Better know and use our *fine shell*.

And if you jouined us, Tim, maybe can share your experience and test
patch above and this one, please?
Message-ID: <E1H9qr4-0002Nu-RL@flower>
Archived-At: <http://permalink.gmane.org/gmane.linux.kernel/485984>

It's just my optimization hint. I have no bc, and i'm sure
things, like that will cause silent misinformation.

Anyway, what is so bad in `sh'?

Thanks.

-*- OT -*-
>   info '(bc)About Expressions and Special Variables'
GFDL. Enough of that bull, even Documentation/ is *free* from it.

Good bye.
--
-o--=O`C  info emacs : not found  /. .\ ( is there any reason to live? )
 #oo'L O  info make  : not found      o (    yes --- R.I.P. FSF+RMS    )
<___=E M  man gcc    : not found    `-- ( viva Debian Operating System )
