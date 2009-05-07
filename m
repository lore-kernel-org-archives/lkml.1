Return-Path: <linux-kernel-owner+w=401wt.eu-S1759002AbZEGUCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002AbZEGUCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbZEGUBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:01:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62901 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbZEGUBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:01:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory Haskins <gregory.haskins@gmail.com>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Date: Thu, 7 May 2009 22:00:21 +0200
User-Agent: KMail/1.9.9
Cc: Avi Kivity <avi@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com>
In-Reply-To: <4A03259B.3050500@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905072200.22007.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+0tRtiPzE72Uhu33NgyxByXs4Qe5fXiPtSiRo
 L15GlsXLeqVzofPYeSGid8n09PN9T9s/YtYEhAe2ckIqNm7HvF
 oK/E4fuQ0WgihWEJGGfhw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 May 2009, Gregory Haskins wrote:
> I guess technically mmio can just be a simple access of the page which
> would be problematic to trap locally without a PF.  However it seems
> that most mmio always passes through a ioread()/iowrite() call so this
> is perhaps the hook point.  If we set the stake in the ground that mmios
> that go through some other mechanism like PFs can just hit the "slow
> path" are an acceptable casualty, I think we can make that work.
> 
> Thoughts?

An mmio that goes through a PF is a bug, it's certainly broken on
a number of platforms, so performance should not be an issue there.

Note that are four commonly used interface classes for PIO/MMIO:

1. readl/writel: little-endian MMIO
2. inl/outl: little-endian PIO
3. ioread32/iowrite32: converged little-endian PIO/MMIO
4. __raw_readl/__raw_writel: native-endian MMIO without checks

You don't need to worry about the __raw_* stuff, as this should never
be used in device drivers.

As a simplification, you could mandate that all drivers that want to
use this get converted to the ioread/iowrite class of interfaces and
leave the others slow.

	Arnd <><
