Return-Path: <linux-kernel-owner+w=401wt.eu-S932982AbZHEAid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbZHEAid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbZHEAib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:38:31 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:34396 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbZHEAia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:38:30 -0400
X-IronPort-AV: E=Sophos;i="4.43,324,1246838400"; 
   d="scan'208";a="360519039"
From: Roland Dreier <rdreier@cisco.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
       akpm@linux-foundation.org
Subject: Re: mmotm 2009-08-04-14-22 uploaded (ummunotify)
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
	<20090804155014.35d4597c.randy.dunlap@oracle.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 04 Aug 2009 17:38:29 -0700
In-Reply-To: <20090804155014.35d4597c.randy.dunlap@oracle.com> (Randy Dunlap's
	message of "Tue, 4 Aug 2009 15:50:14 -0700")
Message-ID: <adafxc7ksca.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Aug 2009 00:38:30.0507 (UTC) FILETIME=[0E0CA3B0:01CA1565]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'
 > 
 > when building for i386.
 > 
 > The get_user() and put_user() in ummunotify_exchange_features()
 > are correctly converted to __get_user_4() and __put_user_4(),
 > but the get_user() in ummunotify_unregister_region() becomes
 > __get_user_X()  [as seen in objdump output].

Is 64-bit get_user() supposed to work portably?  Because it seems that
arch/x86/include/asm/uaccess.h intentionally makes get_user((__u64))
expand to __get_user_X() and then never defines __get_user_X().  And
arm, say, expands it to __get_user_bad().  But on the other hand,
powerpc and sparc seem to go to the trouble of defining a 64-bit
get_user() for 32-bit builds...

My fault for insufficient 32-bit compile testing.  Andrew, I'll send a
patch to change to copy_from_user() instead.

 - R.
