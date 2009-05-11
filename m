Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZEKNC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZEKNC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZEKNCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:02:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZEKNCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:02:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Mon, 11 May 2009 15:01:40 +0200
User-Agent: KMail/1.9.9
Cc: Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
References: <4A031471.7000406@novell.com> <200905080011.52958.arnd@arndb.de> <1241821998.29028.5.camel@pasglop>
In-Reply-To: <1241821998.29028.5.camel@pasglop>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905111501.41563.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19uGoDJ+36AooLdyi6QvIhsACvQFOjCdiB8ItG
 dOmbXLfK56CA2sM3RfPVJTmhmCPogDMR9JKOOK1fRVq0FIwh5n
 Z4cDYl5/9HvxxGAoIUEyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009, Benjamin Herrenschmidt wrote:
> This was shot down by a vast majority of people, with the outcome being
> an agreement that for IORESOURCE_MEM, pci_iomap and friends must return
> something that is strictly interchangeable with what ioremap would have
> returned.
> 
> That means that readl and writel must work on the output of pci_iomap()
> and similar, but I don't see why __raw_writel would be excluded there, I
> think it's in there too.

One of the ideas was to change pci_iomap to return a special token
in case of virtual devices that causes iowrite32() to do an hcall,
and to just define writel() to do iowrite32().

Unfortunately, there is no __raw_iowrite32(), although I guess we
could add this generically if necessary.

> Direct dereference is illegal in all cases though.

right.
 
> The token returned by pci_iomap for other type of resources (IO for
> example) is also only supported for use by iomap access functions
> (ioreadXX/iowriteXX) , and IO ports cannot be passed directly to those
> neither.

That still leaves the option to let drivers pass the IORESOURCE_PVIO
for its own resources under some conditions, meaning that we will
only use hcalls for I/O on these drivers but not on others, as Chris
explained earlier.

	Arnd <><
