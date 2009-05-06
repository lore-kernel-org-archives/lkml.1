Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbZEFWv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbZEFWv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZEFWux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:50:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbZEFWuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:50:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/5] PM/Hibernate: Rework memory shrinking
Date: Thu, 7 May 2009 00:40:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200905070040.08561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset is an attempt to rework the memory shrinking mechanism
used during hibernation to make room for the image.  It is a work in progress
and most likely it's going to be modified, but it has been discussed recently
and I'd like to get comments on the current version.

[1/5] - disable the OOM kernel after freezing tasks (this will be dropped if
        it's verified that we can avoid the OOM killing by using
        __GFP_FS|__GFP_WAIT|__GFP_NORETRY|__GFP_NOWARN
        in the next patches).

[2/5] - drop memory shrinking from the suspend (to RAM) code path

[3/5] - move swsusp_shrink_memory() to snapshot.c

[4/5] - rework swsusp_shrink_memory() (to use memory allocations for applying
        memory pressure)

[5/5] - allocate image pages along with the shrinking.

Details are in the changelogs, please have a look and tell me what you think.

Best,
Rafael



-- 
Everyone knows that debugging is twice as hard as writing a program
in the first place.  So if you're as clever as you can be when you write it,
how will you ever debug it? --- Brian Kernighan

