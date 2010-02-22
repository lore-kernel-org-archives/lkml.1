Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0BVQmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:42:09 -0500
Received: from mail.vyatta.com ([76.74.103.46]:48689 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0BVQmG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:42:06 -0500
Date: Mon, 22 Feb 2010 08:41:48 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Uwe =?UTF-8?B?S2xlaW5lLUvEgsWbbmln?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       WANG Cong <amwang@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Ozan =?UTF-8?B?xIJhZ2xheWFu?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] namespace: perlcritic warnings
Message-ID: <20100222084148.062bc337@nehalam>
In-Reply-To: <daef60381002200026g64b09344m51b798315707179d@mail.gmail.com>
References: <20100219175217.385580142@vyatta.com>
	<20100219175429.826376846@vyatta.com>
	<daef60381002200026g64b09344m51b798315707179d@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010 16:26:24 +0800
Hui Zhu <teawater@gmail.com> wrote:

> On Sat, Feb 20, 2010 at 01:52, Stephen Hemminger <shemminger@vyatta.com> wrote:
> > Use local file handle not global.
> > Make loop and other variables local in scope.
> >
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> >
> >
> > --- a/scripts/namespace.pl      2010-02-19 08:59:00.432184740 -0800
> > +++ b/scripts/namespace.pl      2010-02-19 09:05:52.672644797 -0800
> > @@ -175,12 +175,11 @@ sub do_nm
> >        }
> >        if (! -e "$source.c" && ! -e "$source.S") {
> >                # No obvious source, exclude the object if it is conglomerate
> > -               if (! open(OBJDUMPDATA, "$objdump $basename|")) {
> > -                       printf STDERR "$objdump $fullname failed $!\n";
> > -                       return;
> > -               }
> > +               open(my $objdumpdata, "$objdump $basename|")
> > +                   or die "$objdump $fullname failed $!\n";
> 
> Looks it just want return, are you sure have to change it to die?

Read my previous comment 
> If objdump program is missing program should die with message
> to standard error and exit with non zero status, not continue on!  
