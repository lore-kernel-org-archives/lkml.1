Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZBPB2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZBPB2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZBPB2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:28:45 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:33877 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZBPB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:28:44 -0500
X-IronPort-AV: E=Sophos;i="4.38,213,1233532800"; 
   d="scan'208";a="250019876"
From: Roland Dreier <rdreier@cisco.com>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: pavel@suse.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       axboe@kernel.dk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug 12713] Hang on resume from hibernation, apparently as result  of 213d9417fec
References: <8f53421d0902151605v56c92642ib8c2dcf34fd92ad1@mail.gmail.com>
	<8f53421d0902151607w2985dce6yc1bef7e717166fc@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 15 Feb 2009 17:28:42 -0800
In-Reply-To: <8f53421d0902151607w2985dce6yc1bef7e717166fc@mail.gmail.com>
	(Michael S. Tsirkin's message of "Mon, 16 Feb 2009 02:07:59 +0200")
Message-ID: <adahc2v6ugl.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Feb 2009 01:28:43.0193 (UTC) FILETIME=[E7868A90:01C98FD5]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I haven't read the code in depth, but taking running numbers and doing
 > bitwise "or"
 > on them looks a bit strange to me.
 > So here BIO_RW_SYNC is (3 | 4) = 7, that is the same as BIO_RW_FAILFAST_DEV.
 > So for example bio_failfast_dev and bio_sync are the same.

Yes, this is clearly wrong.  The fix seems to be to delete the
definition of BIO_RW_SYNC, and everywhere that breaks, replace

	1 << BIO_RW_SYNC

with

	(1 << BIO_RW_SYNCIO) | (1 << BIO_RW_UNPLUG)

 - R.
