Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZGTXkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZGTXkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbZGTXkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:40:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:50153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbZGTXkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:40:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [patch 47/54] Staging: hv: make gVmbusConnection.ChannelLock a real spinlock
Date: Tue, 21 Jul 2009 01:39:19 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>, shemminger@linux-foundation.org
References: <20090717180850.873962925@mini.kroah.org> <20090717180923.620590305@mini.kroah.org>
In-Reply-To: <20090717180923.620590305@mini.kroah.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907210139.19672.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18JLVn7NPOSkprTe+f4MohFSC1YY0SRFMvNlS2
 UFCoLYeum9BSRPSnovi/G70ZCv1r7m8dKs2Jp7egQzePSy8art
 xaHunRAFvMpNau+djT6kg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> I don't think we really want to be doing a irqsave for this code, but I
> left it alone to preserve the original codepath.  It should be reviewed
> later.

This patch does not preserve the original code path if any of the
callers has a different irq state from the others. When flags is
shared, releasing the lock actually sets the irq state to whatever
another thread was using when failing to acquire the lock while
it was held.

The patch of course looks good, but the comment is misleading.

	Arnd <><
