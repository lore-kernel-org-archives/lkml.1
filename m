Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXLKVVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXLKVVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 16:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbXLKVV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 16:21:27 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:53122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbXLKVVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 16:21:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [RFC][POWERPC] Provide a way to protect 4k subpages when using 64k pages
Date: Tue, 11 Dec 2007 22:21:15 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
References: <18264.58263.818005.757831@cargo.ozlabs.ibm.com> <20071211155305.GA28055@lst.de>
In-Reply-To: <20071211155305.GA28055@lst.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712112221.17697.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/QLBTEXWwyiVm8MqZfDInVWR2UCE0Kdj0WfSz
 G/wZncvWqqXVuvegqf7rqILjxJQGVOvZ9AeVexsT1tXQszWP13
 QNKR6ASBaIKuHOWTlV7RA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007, Christoph Hellwig wrote:
> Using 4k pages should basically be a pre-process flag
> (which it already is as an implementation detail in your patch), and
> thus the proper way to mark it should be a personality flag.  This
> also means it could be implied by certain personalities, e.g. powerpc
> 32bit for full compatiblity.   All these process would use plain mmap/
> mprotect to deal with the subpage protections.

If you want to make it a per-process flag, wouldn't a prctl bit be more
appropriate than a personality flag? That way you could at least set
it independent from other personality settings.

> At least ia64 and mips have multiple pages sizes already and I suspect
> more architectures will grow support for it.

Another related option might be the alternative page table layouts that
Martin Schwidefsky has implemented for concurrent 2/3/4-level page tables
on s390.

	Arnd <><
