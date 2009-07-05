Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZGELUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZGELUc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZGELUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:20:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbZGELUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:20:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: tom.leiming@gmail.com
Subject: Re: [PATCH 0/3] dma-mapping:remove CONFIG_HAVE_DMA_ATTRS
Date: Sun, 5 Jul 2009 13:19:36 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-10-generic; KDE/4.2.95; x86_64; ; )
Cc: joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1246674895-9610-1-git-send-email-tom.leiming@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200907051319.37169.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/8wAdZgEzvMAUjbRCm+4PER0oLGMJ1WnuP7fn
 Ybse6RGJ6mRtG5ZNuH+uyTgyhOoqptN98CAwRxk3h8zP803gqM
 LphIYbjlWIEwTYRMhpKZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 July 2009, tom.leiming@gmail.com wrote:
> 2,Disabling CONFIG_HAVE_DMA_ATTRS may lead to a compile failure;

I'm not sure I understand this point. CONFIG_HAVE_DMA_ATTRS tells
the common code whether the architecture understands dma attributes.
If you enable it on all architectures, you will get new compile
failures on all those that don't understand them, while the current
code correctly falls back on the standard functions.

I think it makes sense to combine CONFIG_HAVE_DMA_ATTRS with the
use of dma-mapping-common.h, but the majority of the architectures
just uses a static mapping, where attributes make no sense.

You also missed powerpc64, which selects CONFIG_HAVE_DMA_ATTRS
but does not (yet) use dma-mapping-common.h.

	Arnd <><
