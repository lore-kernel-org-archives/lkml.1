Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYC1Xsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYC1Xsv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 19:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYC1Xso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 19:48:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:55572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbYC1Xsn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 19:48:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: down_spin() implementation
Date: Sat, 29 Mar 2008 00:48:21 +0100
User-Agent: KMail/1.9.9
Cc: "Matthew Wilcox" <matthew@wil.cx>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <1FE6DD409037234FAB833C420AA843ECE9DF60@orsmsx424.amr.corp.intel.com> <20080328124517.GQ16721@parisc-linux.org> <1FE6DD409037234FAB833C420AA843ECF237C0@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1FE6DD409037234FAB833C420AA843ECF237C0@orsmsx424.amr.corp.intel.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803290048.22931.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18TisiY6fXaVOITfUNuU41qu63XM64BYPdnkyS
 qPrvyy0PJrLjj9M9MDzq6g37wg2iZXgVY9KrS6a1FAuFGXFT2k
 J7UE1S0taHSZjxRfwO5Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Luck, Tony wrote:
> > So it makes little sense to add this to semaphores.  Better to introduce
> > a spinaphore, as you say.
> 
> > struct {
> >   atomic_t cur;
> >   int max;
> > } ss_t;
> 
> Could this API sneak into the bottom of one or the other of
> linux/include/{spinlock,semaphore}.h ... or should it get its own
> spinaphore.h file?
>
> Or should I follow Alan's earlier advice and keep this as an ia64
> only thing (since I'll be the only user).

If you use the simple version suggested last by Willy, I think it
could even be open-coded in your TLB management code.

Should we decided to make it an official interface, I'd suggest
putting it into atomic.h, because it operates on a plain atomic_t.

	Arnd <><
