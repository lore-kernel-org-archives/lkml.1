Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbZAUASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbZAUASY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:18:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbZAUASO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:18:14 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61257 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbZAUASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:18:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 09/16] dma-debug: add checking for map/unmap_page/single
Date: Wed, 21 Jan 2009 01:17:32 +0100
User-Agent: KMail/1.9.9
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, dwmw2@infradead.org,
       iommu@lists.linux-foundation.org, David Miller <davem@davemloft.net>,
       Oliver Neukum <oliver@neukum.org>, ceggers@gmx.de
References: <1232376423-11067-1-git-send-email-joerg.roedel@amd.com> <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1232376423-11067-10-git-send-email-joerg.roedel@amd.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901210117.33153.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19HcupaIjLajAdfGy13s/6vaKpgck+MWQcULd4
 thJi6ecttFUXRB0nwCcUZlB/VI9A0tnaJ0jqQViJ9k4Uph0p90
 zTE7RUm8+5AYYSMNS/B5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Joerg Roedel wrote:
> Impact: add debug callbacks for dma_{un}map_[page|single]

In the discussion about "[PATCH] usb/mcs7830: Don't use buffers from
stack for USB transfers", I have raised the question of whether we can
add a check for the DMA address being on the stack, I guess this would
be the right place for it.

Maybe you can add another check like:

WARN_ON(is_kernel_stack(page_to_virt(page)));

Unfortunately, I can't think of a way to define a generic is_kernel_stack
function. On most architectures (all that put thread_info at the top of the
stack), something like this should work:

#ifndef is_kernel_stack
static inline int is_kernel_stack(void *p)
{
	return (unsigned long)p & ~(THREAD_SIZE - 1) == current_thread_info();
}
#endif

	Arnd <><
