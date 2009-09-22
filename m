Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZIVNJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZIVNJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZIVNJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:09:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55407 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbZIVNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:09:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] warn about use of uninstalled kernel headers
Date: Tue, 22 Sep 2009 15:09:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-10-generic; KDE/4.3.1; x86_64; ; )
Cc: "Am?rico Wang" <xiyou.wangcong@gmail.com>, Caveh Jalali <ecaveh@gmail.com>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com> <200909211637.12983.arnd@arndb.de> <20090922044310.GA29208@merkur.ravnborg.org>
In-Reply-To: <20090922044310.GA29208@merkur.ravnborg.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909221509.47369.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Zyb9jDWfRzepwRX6WfLTazjwu3XPMKbpl+bb
 nde5ynh7S+GA1yYDUZSbXHx8UQrMgIMLwrL2z5UT2NTAo8F6oM
 BUUF3+QxTRbLSvGp5Veew==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 September 2009, Sam Ravnborg wrote:
> > +#ifndef __EXPORTED_HEADERS__
> But why do we need this "__EXPORTED_HEADERS__" thing?
> 
> ?

The problem is that the warning should only be for headers
that are not installed yet, but it needs to be stripped
in the installed version. Since we're already postprocessing
all files with unifdef, that seemed like the easiest way 
to strip out the #warning. Obviously, I couldn't use the
#ifdef __KERNEL__ logic, because that would either warn
give false positives when building kernel code or when
building user code from installed headers.

	Arnd <><
