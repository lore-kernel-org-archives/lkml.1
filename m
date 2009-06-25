Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZFYLa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZFYLa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZFYLaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:30:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZFYLaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:30:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Ungerer <gerg@snapgear.com>
Subject: Re: [uClinux-dev] [PATCH] m68k: restore lost coldfire CLOCK_TICK_RATE
Date: Thu, 25 Jun 2009 13:30:09 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org
References: <20090620201147.GA14095@frolo.macqel> <20090624211144.GA13167@frolo.macqel> <4A42C5DC.1040103@snapgear.com>
In-Reply-To: <4A42C5DC.1040103@snapgear.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906251330.10127.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Qk8+85HuxWzn1NjvbkxkkRxsRFU46vLp1GQj
 nTQAtyojIQRJGtlZTLbVnAvzWsfbGhHqKTIoAsdKZE8rWTpogI
 low3nsncEXZ+VZcupEjNA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 June 2009, Greg Ungerer wrote:
> I thought it did that based on gettimeofday()?  And that ends up
> going through the underlying timer code, which for both of
> the ColdFire timer types doesn't use CLOCK_TICK_RATE. They directly
> use the MCF_CLK definition.

The problem is the definition of TICK_NSEC, which is calculated from
CLOCK_TICK_RATE. If you use the i8253 PIT tick rate, this will be
slightly different from the regular TICK_NSEC value of (1000000000 / HZ).

	Arnd <><
