Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbZAPM3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbZAPM3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 07:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760869AbZAPM3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 07:29:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760689AbZAPM3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 07:29:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: nbd: add locking to nbd_ioctl
Date: Fri, 16 Jan 2009 13:29:08 +0100
User-Agent: KMail/1.9.9
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul.Clements@steeleye.com
References: <20090116115512.GA10771@elf.ucw.cz>
In-Reply-To: <20090116115512.GA10771@elf.ucw.cz>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161329.08588.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18YaloUI1YFfysscLwX9B2amRJLoPBmskwsqnZ
 tLdQvYVomfA1AcfgA/Iv2UScyEtaDMlWnuwMRLFVLqRm2sN3CZ
 tIuynKU8XOHPAxgVicYJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009, Pavel Machek wrote:
> The code was written with "oh big kernel lock, please protect me from
> all the evil" mentality: it does not locks its own data structures, it
> just hopes that big kernel lock somehow helps.

If the locking is ok now, can you also move the call to ->ioctl()? instead
of locked_ioctl()? That would also be a good opportunity to move to
compat_ioctl() and kill the handlers in fs/compat_ioctl.c.

	Arnd <><
