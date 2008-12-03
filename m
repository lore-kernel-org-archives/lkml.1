Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbYLCM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbYLCM0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYLCM0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:26:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56823 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYLCM0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:26:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: New location for generic headers?
Date: Wed, 3 Dec 2008 13:26:01 +0100
User-Agent: KMail/1.9.9
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de> <20081203120110.GA2822@uranus.ravnborg.org>
In-Reply-To: <20081203120110.GA2822@uranus.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031326.01859.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sKLc7Ybn8h68XvABDCP/X8AUCeBiLnfvwpqI
 h++Eo9HQCQ0HB/qNQnU9ifuRpm32kIYzQfOAZ8TX770f5Ol9Qg
 IaPQiOLL7r4Lb9tFlfp8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008, Sam Ravnborg wrote:
> On Wed, Dec 03, 2008 at 11:40:01AM +0100, Arnd Bergmann wrote:
>
> > I'm working on patches to consolidate a lot of generic headers, why not
> > add this in a generic way and make x86 use that version?
> 
> Should we try to get rid of all those silly:
> #include <asm-generic/foo.h>
> files we have in arch/$ARCH/include/asm?
> 
> We could for example add include/generic/ last in the search path.
> Or we could add the files in include/asm and add that last in the
> search path.

My current idea is to have an explicit list of asm-generic headers
that can act as drop-in replacements, either in include/asm-generic/Makefile
or in arch/*/include/asm/Makefile, and then generate these trivial
wrappers in $(objdir)arch/*/include/asm/ and $(INSTALL_HDR_PATH)/asm
if it doesn't already exist there.

This way we don't have to change all the headers that do #include
<asm-generic/foo.h> plus something else.
 
	Arnd <><
