Return-Path: <linux-kernel-owner+w=401wt.eu-S1757568AbZHGMCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbZHGMCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 08:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZHGMCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 08:02:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62603 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbZHGMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 08:02:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Date: Fri, 7 Aug 2009 14:02:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <200908070904.11260.arnd@arndb.de> <20090807080428.GB4955@nowhere>
In-Reply-To: <20090807080428.GB4955@nowhere>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908071402.11217.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hXX+oFMons3SHInebfRB57kBLHZ0+gWfthkq
 78dfBACTXTuKH7DK3JfbqIiesQcCy/kZnF4oEdBTvB9y591tvr
 ev0tAUbAizSVKYx1bQ6bg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Frederic Weisbecker wrote:
> Ok. This looks like a nice series. A bkl pushdown that only goes down
> in one site among several others enlightens the understanding of what it
> is protecting (beside the nice fact it also burned three bkl callsites :-)

Thanks!

Well, most importantly patch 5/5 fixes a long-standing bug where we held
the BKL in lots of places that were already proven not to need it, or
alternatively held it twice (nested) in the ioctls that may still need it.

I did patch 3/5 this way because I read that you were working on BKL
removal for TTY and wanted to do my share by removing the dependency
on the code that I care about (fs/compat_ioctl.h).

	Arnd <><
