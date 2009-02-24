Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbZBXXtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbZBXXtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZBXXsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:48:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921AbZBXXst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:48:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: virtually and physically (page) aligned allocation
Date: Wed, 25 Feb 2009 00:48:08 +0100
User-Agent: KMail/1.9.9
Cc: Parav Pandit <paravpandit@yahoo.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
References: <389971.28411.qm@web30104.mail.mud.yahoo.com> <49A39489.3090202@zytor.com>
In-Reply-To: <49A39489.3090202@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902250048.09160.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18L2i+JAfFaX2pm/NtkRvAYtru7hxhLrzh10GF
 rTVCm/exPKunux+E0MD2TYBpT56aOs4IR8hx0RNcl7EaYcx7TN
 CXxqfYlw9fgret7N3fSTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, H. Peter Anvin wrote:
> Parav Pandit wrote:
> > In other way,
> > If user space application allocates memory which is aligned to page
> > boundary for say 4 pages using posix_memalign(), will is ensure that
> > it corresponds to exactly 4 physical pages in kernel which can be pinned down?  
> > 
> 
> You can use hugetlbfs to allocate a 2 MB page, otherwise no.

Well, posix_memalign should be able to give you alignment of up to page size
in real addresses (which I think is what Parav was asking for), but can not
guarantee larger than page size real alignment.

If an address is page aligned in user space, it is also guaranteed to be
page aligned in real storage. Alignment larger than page size can not be
forced or detected in user space except when using hugetlbfs.

	Arnd <><
