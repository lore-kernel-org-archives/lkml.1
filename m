Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbZAUIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbZAUIZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbZAUIZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:25:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbZAUIZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:25:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Helge Deller <deller@gmx.de>
Subject: Re: Confusion in usr/include/asm-generic/fcntl.h
Date: Wed, 21 Jan 2009 09:24:22 +0100
User-Agent: KMail/1.9.9
Cc: David Miller <davem@davemloft.net>, jaswinder@kernel.org, mingo@elte.hu,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
References: <1232496257.3123.19.camel@localhost.localdomain> <20090120.163203.199590606.davem@davemloft.net> <4976D937.5040704@gmx.de>
In-Reply-To: <4976D937.5040704@gmx.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210924.23484.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+lFiLv4fm9rqYjP2MjQnD+HZKhatzUsWTJGhE
 hWzykKW/5JZGnoJg8AGqwLSHPeoBiH3I7Ht3pVVuOk4mL5OJt1
 lUvP/H0MUg4UIPEEDKH0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 January 2009, Helge Deller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> >> On parisc, there is a major confusion in this area, at some point, all
> >> checks for __LP64__ got replaced with CONFIG_64BIT there. While I have
> >> not understood what the problem with __LP64__ was, the check for
> >> CONFIG_64BIT on parisc user space looks very wrong.
> 
> I think the parisc mess is my fault. I once replaced the __LP64__ by 
> CONFIG_64BIT and forgot that some files are exported to userspace.
> I'll clean that up and send patches.

I have a patch set that introduces a lot more asm-generic headers where
I also need a generic way to check for this. The approach I chose
here was to check "#if __BITS_PER_LONG == 64" for anything that is
exported to user space. Maybe you can #define this in asm/types.h
and use this check in the parisc headers as well.

	Arnd <><
