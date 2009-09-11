Return-Path: <linux-kernel-owner+w=401wt.eu-S1753796AbZIKLwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbZIKLwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZIKLwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:52:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZIKLwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:52:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
Date: Fri, 11 Sep 2009 13:50:14 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-9-generic; KDE/4.3.1; x86_64; ; )
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
References: <20090910060627.GA24343@us.ibm.com> <200909111334.45241.arnd@arndb.de> <1252669205.7126.23.camel@laptop>
In-Reply-To: <1252669205.7126.23.camel@laptop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200909111350.15004.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18L5TXNYbZisw4B62iLsRrADlqe8Sju2XJ2W29
 V4Lk4g5MegM/u/sMoZVzAfYQF7SmU/lSaL/rN1FC6knyV1viM6
 /8onpbmCnbq15z+Oj1aHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009, Peter Zijlstra wrote:
> On Fri, 2009-09-11 at 13:34 +0200, Arnd Bergmann wrote:
> > On Friday 11 September 2009, Peter Zijlstra wrote:
> 
> > > If you then get passed a longer clone_struct than you know about, all is
> > > well IFF the tail is 0, otherwise fail with -E2BIG.
> > > 
> > > If you get passed a short clone_struct, zero out the tail.
> > 
> > I would leave out the size argument. We can put a few reserved fields
> > and flag bits in there for possible extensions, but if we ever run out
> > of these, just define a new syscall.
> 
> Why? If we can avoid this new syscall isn't that nicer?

There is a limit to how much flexibility I would aim for. In the last
fourty years, we needed three revisions of that call (fork, clone,
clone2). By invalid extrapolation, adding room for another extension
should give us at least twenty years ;-)

Also, the flags field basically has the same purpose are the size field,
so we do not need both. In the worst case, you can define one of the
flags to mean 'the structure is now 168 bytes long'.

	Arnd <><
