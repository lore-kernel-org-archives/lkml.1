Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbZABX7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbZABX7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZABX71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:59:27 -0500
Received: from mout-xforward.kundenserver.de ([212.227.17.6]:58755 "EHLO
	mout-xforward.kundenserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbZABX70 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:59:26 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Sat, 3 Jan 2009 00:59:18 +0100
User-Agent: KMail/1.9.9
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <200812311758.04516.arnd@arndb.de> <200812311732.40076.vapier@gentoo.org>
In-Reply-To: <200812311732.40076.vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901030059.18438.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+X35cXqCWJWiHE2BEgRFiGoTTvQBTHs0I6Fk4
 oQYU84RdvouQrj/L2sq+AeIDpOR+Avlch1PoXkk7a4OYGOh14c
 uP/R+EqkN/EGsNNwk1fPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008, Mike Frysinger wrote:
> On Wednesday 31 December 2008 11:58:03 Arnd Bergmann wrote:
>
> > Not sure if we can detect the other form reliably from perl.
> 
> yes, i already mentioned both of these issues.  that's why i suggested we 
> start adding "extern" to all the headers (or at least the userspace ones).

The general trend seems to be to remove the "extern" keyword from
kernel headers, because it is not interpreted, just like the 'auto'
keyword. In fact, only few of them currently carry the extern keyword:

$ ctags -f- -R --c-kinds=p obj/usr/include/  | grep extern | wc -l
33

$ ctags -f- -R --c-kinds=p obj/usr/include/  | grep -v extern | wc -l
191

Note that this is a completely separate issue from extern variable
declarations, which should to be disallowed in any case, and are easy
to detect as they always require the extern keyword.

	Arnd <><
