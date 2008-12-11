Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbYLKXZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbYLKXZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 18:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbYLKXZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 18:25:05 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6570 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbYLKXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 18:25:03 -0500
X-IronPort-AV: E=Sophos;i="4.36,207,1228089600"; 
   d="scan'208";a="211424313"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Nguyen Anh Quynh <aquynh@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Kuniyasu Suzaki <k.suzaki@aist.go.jp>
Subject: Re: [PATCH] fix calls to request_module()
References: <9cde8bff0812101935j5ef56140k67035d892a868738@mail.gmail.com>
	<20081211040118.GK28946@ZenIV.linux.org.uk>
	<20081210201455.0c611484.akpm@linux-foundation.org>
	<20081211044901.GL28946@ZenIV.linux.org.uk>
	<adatz9b2thy.fsf@cisco.com>
	<20081210214142.9e7b2298.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 11 Dec 2008 15:25:01 -0800
In-Reply-To: <20081210214142.9e7b2298.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 10 Dec 2008 21:41:42 -0800")
Message-ID: <adahc5a2t2q.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Dec 2008 23:25:01.0992 (UTC) FILETIME=[B0E1A280:01C95BE7]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I wonder if we could add a printk_stfu() which isn't declared
 > attribute(printf) and which simply calls printk.  We might still get a
 > single warning at the interface point.

That would fix the class of warnings like

	printk(char_pointer_gcc_doesnt_know_is_safe);

but therre are alsofunctions like device_create() etc etc where someone
could easily and legitimately do the same thing.

 - R.
