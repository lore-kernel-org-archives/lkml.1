Return-Path: <linux-kernel-owner+w=401wt.eu-S1750820AbXBVMxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750820AbXBVMxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 07:53:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXBVMxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 07:53:04 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:34556 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbXBVMxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 07:53:00 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Date: Thu, 22 Feb 2007 14:53:15 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       lkml <linux-kernel@vger.kernel.org>, spock@gentoo.org
References: <200702090838.21060.caglar@pardus.org.tr> <200702151300.41343.caglar@pardus.org.tr> <1172101421.4217.20.camel@daplas>
In-Reply-To: <1172101421.4217.20.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3834291.GLqn8Nfp8J";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702221453.18153.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3834291.GLqn8Nfp8J
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

22 =C5=9Eub 2007 Per tarihinde, Antonino A. Daplas =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> On Thu, 2007-02-15 at 13:00 +0200, S.=C3=87a=C4=9Flar Onur wrote:
> > 15 =C5=9Eub 2007 Per tarihinde, Andrew Morton =C5=9Funlar=C4=B1 yazm=C4=
=B1=C5=9Ft=C4=B1:
> > > On Thu, 15 Feb 2007 11:40:32 +0100 Pavel Machek <pavel@ucw.cz> wrote:
> > > > Contact fbcon people...
> > >
> > > There aren't any, basically.  Since Tony disappeared James has been
> > > helping out but doesn't have a lot of time.  So we're pretty much on
> > > our own with problems in this area.
> >
> > I already sent same mail to
> > linux-fbdev-devel mailing lists at sf.net with hope :)
> >
> > Cheers
>
> Interesting... It does look like this was triggered by calling
> do_blank_screen() without taking the console semaphore, but
> console_callback() should have taken that.
>
> Second point is that vesafb does not have any blanking functionality,
> thus it should not trigger fbcon_event_notify().  My guess is you are
> using an out-of-tree vesafb?

As i wrote we are using vesafb-tng [http://dev.gentoo.org/~spock/projects/]=
=20
for a long time but this hits me only with 2.6.20 and only after=20
suspend2disk, so im adding Micha=C5=82 Januszewski to CC if this is vesafb-=
tng=20
related :).

> BUG: at drivers/char/vt.c:3332 do_blank_screen()
>  [<c02881f7>] do_blank_screen+0x4e/0x218
>  [<c02977fa>] fbcon_event_notify+0x8f1/0xa1e
>  [<c027b2b0>] extract_buf+0xac/0xe1
>  [<c0102002>] __switch_to+0xeb/0x15d
>  [<c034bbe5>] __sched_text_start+0x865/0x929
>  [<c029a50d>] bit_cursor+0x4c8/0x50b
>  [<c034bd67>] wait_for_completion+0x79/0xaf
>  [<c011cbe2>] default_wake_function+0x0/0xc
>  [<c034ece2>] notifier_call_chain+0x19/0x32
>  [<c012d1c6>] blocking_notifier_call_chain+0x23/0x33
>  [<c028db54>] fb_blank+0x4a/0x53
>  [<c0299028>] fbcon_blank+0xf4/0x1e3
>  [<c0294f33>] fbcon_cursor+0x21c/0x250
>  [<c029a045>] bit_cursor+0x0/0x50b
>  [<c0129e90>] lock_timer_base+0x15/0x2f
>  [<c0129eee>] try_to_del_timer_sync+0x44/0x4a
>  [<c0298f34>] fbcon_blank+0x0/0x1e3
>  [<c028835a>] do_blank_screen+0x1b1/0x218
>  [<c028abdd>] console_callback+0xaf/0xbf
>  [<c012fa59>] run_workqueue+0x85/0x135
>  [<c028ab2e>] console_callback+0x0/0xbf
>  [<c01302f0>] worker_thread+0x10a/0x136
>  [<c011cbe2>] default_wake_function+0x0/0xc
>  [<c01301e6>] worker_thread+0x0/0x136
>  [<c0132982>] kthread+0xb2/0xdc
>  [<c01328d0>] kthread+0x0/0xdc
>  [<c0103a8f>] kernel_thread_helper+0x7/0x10
>
> As for the last tracing, it looks to be valid bug to me.
> complete_change_console() should be called with the console sem
> taken. I'll look into this.

If testing needed just ask please :)

> BUG: at drivers/char/vt.c:3486 set_palette()
>  [<c0287538>] set_palette+0x41/0x59
>  [<c028886f>] redraw_screen+0x110/0x17e
>  [<c0282394>] complete_change_console+0x2a/0xba
>  [<c028ab73>] console_callback+0x45/0xbf
>  [<c012fa59>] run_workqueue+0x85/0x135
>  [<c028ab2e>] console_callback+0x0/0xbf
>  [<c01302f0>] worker_thread+0x10a/0x136
>  [<c011cbe2>] default_wake_function+0x0/0xc
>  [<c01301e6>] worker_thread+0x0/0x136
>  [<c0132982>] kthread+0xb2/0xdc
>  [<c01328d0>] kthread+0x0/0xdc
>  [<c0103a8f>] kernel_thread_helper+0x7/0x10
>
> Tony

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3834291.GLqn8Nfp8J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF3ZI+y7E6i0LKo6YRAgltAJ40jffEQOHA6mGBTW+Fv6HUirFCVACg1Q+y
EJNuhiVJmaVvTqv/sZwFI3Y=
=5TAk
-----END PGP SIGNATURE-----

--nextPart3834291.GLqn8Nfp8J--
