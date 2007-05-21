Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbXEUWCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbXEUWCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXEUWB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:01:58 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:43324 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbXEUWB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nl0f7Mow5iWCa3525ceWIlaFehKrCogcFUsH+fi199mx9R87kQPKqo6gIJawpAyf51Fk08N3W1PP9ABJdM+NjE1LiN5Fwbgw2NOcbJru6+4SO+01msizGg8L0ta7UnVrEFWtJ0o423obNL9+8bgKOW1zxd+rnNMhVPKbG9X0sX8=
Message-ID: <8bd0f97a0705211501h3684ec80kc74af2cc898806aa@mail.gmail.com>
Date: Mon, 21 May 2007 18:01:57 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200705211752.06709.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179742180228-git-send-email-bryan.wu@analog.com>
	 <200705211035.08380.rgetz@blackfin.uclinux.org>
	 <8bd0f97a0705211036q1162e9edvd73af8d6c536e565@mail.gmail.com>
	 <200705211752.06709.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> On Mon 21 May 2007 13:36, Mike Frysinger pondered:
> > On 5/21/07, Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> > > since there is noMMU, are we better:
> > >  - putting stubs (return ENOSYS - give runtime errors), or
> > >  - just ignore the errors - and give compile errors? (Is there any way to
> > > put something into the syscall table, as not to get the warnings?)
> >
> > there are no compile errors ... having a stub that returns -ENOSYS is
> > the same thing as not having a stub as the fallback code when given an
> > unknown syscall # will return -ENOSYS ...
>
> So, is there a way to tell ./scripts/checksyscalls.sh that here is a list of
> syscalls that we can't do/have chosen not to implement - so we can live with
> the common fallback code, and not get the warnings?

we'd have to define some lists ... like an "obsolete" list where we
could say "do not warn about function XXX if function YYY is supplied"
... for example, we dont provide mmap() because we only use mmap2()
...

then we'd need a list for no-mmu where we could list ones that dont
make sense for us ...

to be sure, there are functions in that list we should be implementing
but no one has noticed/complained so it hasnt been an issue ;)
-mike
