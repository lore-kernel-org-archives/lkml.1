Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbZGXJXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbZGXJXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZGXJXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:23:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZGXJXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:23:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: generic uaccess.h
Date: Fri, 24 Jul 2009 11:20:22 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
References: <4A69651E.7040305@monstr.eu>
In-Reply-To: <4A69651E.7040305@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907241120.22483.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+QfTE81zlocCl62p0p0laNcZO67o6OG8APMFJ
 KJMCL73dKf7r63C3ow9tnews2wIpt5T+OLb/xhumK7PSgMO8Bv
 iQrVPUyfTgnE6qggvMAvA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 July 2009, Michal Simek wrote:
> I have just look at asm-generic uaccess.h and there is one thing which
> seems to me wrong.
> 
> For put_user macro - you use __copy_to_user but you have for 64bit case
> ifdef CONFIG_64BIT
> but  look at fs/eventfd: eventfd_read function. At least for this
> function(syscall) is necessary "return" 64bit
> value on 32bit machines too.
> IMHO that ifdef CONFIG_64BIT shouldn't be there.
> 
> What do you think?
> If you agree with me, I'll generate proper patch with description.

The code was intentional, because 32 bit architectures normally
don't acces u64 values efficiently. I would expect the memcpy
to produce better object code in that case.
Did you see an actual bug in my version or are you only
guessing that the assignment should work better than the
memcpy?

What object code do you get with

int test(unsigned long long __user *out, unsigned long long in)
{
	return put_user(in, ptr);
}

in both cases?

	Arnd <><
