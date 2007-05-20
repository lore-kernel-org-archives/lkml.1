Return-Path: <linux-kernel-owner+w=401wt.eu-S1763579AbXETALl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763579AbXETALl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 20:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbXETALe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 20:11:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52007 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbXETALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 20:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VOifsiWMpgD4kt5dxPOEiRBvipgZJS+h0bd1wQWKqRbzAWXv/pyVQntmP/e08WWMlEq70QZLrVmvEB4abcgKuZE+KYQ6AwWDs4P6drbOwy8PofOB/Ioh6RZiqnv2XjFQrkiQEbDh++ze8nc74qcvKa3+jncdYGz1EM9HDictv0Q=
Message-ID: <a781481a0705191711v7f4f93e4r9dfd7e5cbc0ddef4@mail.gmail.com>
Date: Sun, 20 May 2007 05:41:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <20070520000235.GP6291@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <20070519230537.GI6291@stusta.de>
	 <20070519162239.1bcb03d6.akpm@linux-foundation.org>
	 <20070520000235.GP6291@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sat, May 19, 2007 at 04:22:39PM -0700, Andrew Morton wrote:
> > On Sun, 20 May 2007 01:05:37 +0200 Adrian Bunk <bunk@stusta.de> wrote:
> >
> > > Look for example at the last one in drivers/input/mouse/Kconfig:
> > >
> > > config MOUSE_ATARI
> > >         tristate "Atari mouse"
> > >         depends on ATARI
> > >         select ATARI_KBD_CORE
> > >
> > > This is perfectly correct (the select'ed symbol is only unavailable when
> > > the dependency can't be fulfilled), and all things to "fix" the warning
> > > will make it worse.
> >
> > If ATARI is unset then we shouldn't be generating the "'select' used by
> > config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'"
> > warnings, should we?
>
> Exactly.

But I suspect we do wish to get rid of the bogus warnings? (similar to
other places in arch/.../Kconfig's where such cases are handled) ...
_that_ (suppressing these four bogus warnings) was the purpose of that
patch in the first place .....
