Return-Path: <linux-kernel-owner+w=401wt.eu-S1759612AbZFNUOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612AbZFNUOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZFNUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:14:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:62066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZFNUOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:14:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 1/4] asm-generic: uaccess: do not expand args multiple times
Date: Sun, 14 Jun 2009 22:14:39 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244959204-11269-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-15?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-15?q?Y=2Ea=5E3zb?=)
 =?iso-8859-15?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-15?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142214.40532.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2/wkxvqnIJfgwxZLGrYtzfSD8on8F5ubVzyG
 oRi0R2mntgJIQ0G/oV6zh8kZLRxlgUVC0InKsb+IoiO93KThEb
 peUWyPss477rnEzg3QMEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 June 2009, Mike Frysinger wrote:
> While it's debatable whether {get,put}_user() should be called with
> arguments that have side effects, macro's should be written safely in the
> first place.  In this case, a slightly off version of put_user() ended up
> causing random userspace corruption and these things aren't trivial to
> track down.
> 
> While some of these conversions aren't strictly necessary, I think it's
> better to do all of them so as to be proactive in people accidently
> screwing it up in the future.

I've tried this and failed. This change adds an endless number of sparse
warnings in put_user and even gcc warnings in get_user. The problem
is that typeof() carries over the 'const' and '__user' modifiers, both
of which prevent you from assigning data to the new pointer that you
constructed.

I'd love to see a way to do this correctly, but this patch won't cut it.

	Arnd <><
