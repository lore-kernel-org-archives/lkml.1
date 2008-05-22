Return-Path: <linux-kernel-owner+w=401wt.eu-S935247AbYEVWxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935247AbYEVWxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760368AbYEVWw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:52:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbYEVWw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:52:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Date: Fri, 23 May 2008 00:52:45 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <20080522013035.GV28946@ZenIV.linux.org.uk>
In-Reply-To: <20080522013035.GV28946@ZenIV.linux.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805230052.46976.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX190qo7LUFKqnfBnkCHoRJUAHbOqmI0k6r69mXE
 IlcqAYU8kzBQQ2pzEfs8PPmi3LyLfWnHIU4F/HVF+G3bNnEUGJ
 ZVTYT/KciKOqiRzlJo/lg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2008, Al Viro wrote:

> On Wed, May 21, 2008 at 06:20:27PM -0700, Linus Torvalds wrote:
> > On Thu, 22 May 2008, Al Viro wrote:
> > 
> > > Nice, but... how do you pull what's currently asm-generic/foo.h from what's
> > > currently asm-bar/foo.h?  #include_next is _ugly_...
> > 
> > I was actually going to suggest #include_next, yes. But if people hate it, 
> > we can certainly just keep the current <asm-generic/xyz.h> approach.
> 
> Another alternative is to replace asm-generic/ with generic/asm and have
> -I include -I arch/$ARCH/include -I include/generic. Then we'd have

Neither #include_next nor the generic/asm approach seems to have a
straightforward way of handling exported user space headers.
The current include/asm-generic way of doing this isn't nice either,
but at least it's a known evil.

Since the question of asm-generic is almost entirely independent of 
where the regular arch headers are, I'd vote for leaving asm-generic
alone for now and only doing the obvious move of all other headers to
arch/*/include/asm as a significant step in the right direction.
Nobody seemed to object that part so far, and the only significant
changes it needs are in sparc64, m68knommu and um as well as a few
scripts changes.

	Arnd <><
