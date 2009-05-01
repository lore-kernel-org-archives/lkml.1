Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZEAMgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZEAMgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbZEAMgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:36:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:56832 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZEAMgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:36:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 12/27] asm-generic: add a NOMMU uaccess.h
Date: Fri, 1 May 2009 14:36:04 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <45b4644e80c27b9d042b3960e3d99f0d444e0d92.1241105648.git.arnd@arndb.de> <c1a198be0904302337x714621d8xc4685a634c5cf222@mail.gmail.com>
In-Reply-To: <c1a198be0904302337x714621d8xc4685a634c5cf222@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Disposition: inline
Message-Id: <200905011436.05204.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18IvMJj7n5ZLJ1hPgr2b0pk7W87TgyXBarRRoC
 N+CXt37DET2fbNgNn4iITzWcudg6Mxy5RT5QbXOZEGd9e/Ii4J
 ZjiMZO9os78bMQkzVjilQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n41CaRqu010708

On Friday 01 May 2009, Michal Simek wrote:> > +#ifndef __put_user> > +#define __put_user(x, ptr)                             \> > +({                                                     \> > +       int __pu_err = 0;                               \> > +       typeof(*(ptr)) __pu_val = (x);                  \> > +       switch (sizeof (*(ptr))) {                      \> > +       case 1:                                         \> > +       case 2:                                         \> > +       case 4:                                         \> > +               *(ptr) = (__pu_val);                    \> > +               break;                                  \> > +       case 8:                                         \> > +               memcpy(ptr, &__pu_val, sizeof (*(ptr)));\> > > potential cast problem
Yes, I'm looking into this already, probably will do somethingbased on the s390 code, which seems to do this correctly.
> > +#define put_user(x, ptr) (                             \> > +       access_ok(VERIFY_WRITE, ptr, sizeof (*ptr)) ?   \> > +               __put_user(x, ptr) :                    \> > +               -EFAULT)> > > IMHO write it as inline function with type checking.
Unfortunately, this doesn't work because of the callinconventions: __put_user needs to know the type of ptr,so it has to be a macro.
	Arnd <><ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
