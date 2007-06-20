Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbXFTU3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbXFTU3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbXFTU32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:29:28 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:51722 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbXFTU31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:29:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAOoqeUarR7MV/2dsb2JhbAA
X-IronPort-AV: i="4.16,444,1175497200"; 
   d="scan'208"; a="496214419:sNHT31164952"
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Spinlock init
X-Message-Flag: Warning: May contain useful information
References: <46798A37.6050007@hawkeye.stone.uk.eu.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 20 Jun 2007 13:29:14 -0700
In-Reply-To: <46798A37.6050007@hawkeye.stone.uk.eu.org> (Jack Stone's message of "Wed, 20 Jun 2007 21:12:39 +0100")
Message-ID: <ada4pl29xph.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 Jun 2007 20:29:14.0399 (UTC) FILETIME=[AAF5AAF0:01C7B379]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > can rwlock_init and spin_lock_init be used outside of functions declared
 > __init. The spinlock documentation suggests that it can't but I'd like
 > someone to confirm that.

Those function can be used in any function.  A function is declared
__init if it only runs during the kernel startup, so that the memory
holding the code for __init functions can be freed once startup is
done.  However, spin_lock_init() is just used to initialize a freshly
allocated spinlock, and spinlocks may be allocated at any time, even
long after the kernel is done starting up.  A quick look throught
kernel source code will show many, many examples where
spin_lock_init(), rwlock_init(), mutex_init(), etc. are called from
non-__init functions.


 - R.
