Return-Path: <linux-kernel-owner+w=401wt.eu-S1754663AbYEDWzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbYEDWzH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 18:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYEDWyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 18:54:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:60935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYEDWyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 18:54:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: microblaze syscall list
Date: Mon, 5 May 2008 00:54:19 +0200
User-Agent: KMail/1.9.9
Cc: monstr@seznam.cz, microblaze-uclinux@itee.uq.edu.au,
       Matthew Wilcox <matthew@wil.cx>, Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       John Williams <john.williams@petalogix.com>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <481D7DF7.3000909@seznam.cz> <481E3433.2030408@zytor.com>
In-Reply-To: <481E3433.2030408@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805050054.20903.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+yMsSZ6ZFMO+QVS+ulPl6HifqbDjuLjj1AH6n
 wVZSmq1lnUpLfZQdqs/7ntd5m90Wa3VpnCkAdaPRewE2GIyTVx
 II8Y+yfitm1E1GufylfXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008, H. Peter Anvin wrote:
> Michal Simek wrote:
> > /* fs/select.c */
> >       .long sys_select /* obsolete -> sys_pselect6 */
> > ok    .long sys_pselect7
> >       .long sys_pselect6 /* obsolete -> sys_pselect7 */
> 
> I thought there was some semantic differences between select() and 
> pselect()... perhaps those changes have been removed?

According to the main page, there are three differences:

* POSIX pselect does not update the timeout argument, but linux pselect7
does, so it's easy to implement both pselect and select based on it.
* pselect also has a timespec arguement, not timeval as select, but that's
trivial to convert.
* pselect obviously takes an extra argument, but if that's NULL, it will
behave like select (aside from the timeout handling).

	Arnd <><
