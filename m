Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbZJELnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbZJELnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 07:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbZJELnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 07:43:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39201 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757257AbZJELnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 07:43:10 -0400
X-Sasl-enc: MnZ4t8Zwh4AoV6GAdz/HNvVpGQOEt6sYlZNuE1EZgueb 1254742952
Message-ID: <4AC9DBA5.1090701@imap.cc>
Date: Mon, 05 Oct 2009 13:42:29 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.23) Gecko/20090825 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: i4ldeveloper@listserv.isdn4linux.de, Carsten Paeth <calle@calle.de>,
       Karsten Keil <isdn@linux-pingi.de>, Karsten Keil <keil@b1-systems.de>,
       Armin Schindler <armin@melware.de>, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] isdn/capi: fix up CAPI subsystem workaround locking
 a bit
References: <20091003120657.2228911186C@xenon.ts.pxnet.com> <200910032026.24451.mb@bu3sch.de> <200910032035.21884.mb@bu3sch.de>
In-Reply-To: <200910032035.21884.mb@bu3sch.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sat, 2009-10-03 20:35:19 +0200, Michael Buesch wrote:

>> I remember that handle_minor_send() and/or handle_minor_recv() showed up
>> in the crash backtraces. So if you move them out of the critical
>> section, you can as well remove the lock completely.
> 
> here's my original mail:
> http://lkml.indiana.edu/hypermail/linux/kernel/0605.0/0455.html
> 
> Note the patch in that mail does _not_ fix the issue, as it turned out later.
> Then I did the workaround-lock patch, which _did_ fix it.

Thanks for the info. So do I understand correctly that after:

commit 6aa65472d18703064898eefb5eb58f7ecd0d8912
Author: Michael Buesch <mb@bu3sch.de>
Date:   Mon Jun 26 00:25:30 2006 -0700

    [PATCH] CAPI crash / race condition

you were actually still seeing LIST_POISON2 Oopses in
capiminor_del_ack(), but after:

commit 053b47ff249b9e0a634dae807f81465205e7c228
Author: Michael Buesch <mb@bu3sch.de>
Date:   Mon Feb 12 00:53:26 2007 -0800

    [PATCH] Workaround CAPI subsystem locking issue

they were gone? That's interesting. I'll try to wrap my mind around
this. capiminor_del_ack() isn't that big, after all.

It's unfortunate that these crashes only seem to occur with one specific
device (FritzCard DSL) which I don't have. Can anyone shed some light on
what that device is doing differently from other ISDN cards?

Thanks,
Tilman

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFKydulQ3+did9BuFsRAsYVAJ9e5azOPmNycMHZM6onfsDIY21a5wCffNh5
14WY2tYjla7wmmVgCHe+qDo=
=BgmY
-----END PGP SIGNATURE-----
