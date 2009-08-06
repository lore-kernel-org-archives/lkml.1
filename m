Return-Path: <linux-kernel-owner+w=401wt.eu-S932214AbZHFXrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214AbZHFXrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbZHFXrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:47:32 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:35151 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbZHFXrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:47:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABcIe0qrR7PD/2dsb2JhbAC5LogqkCgFhBg
X-IronPort-AV: E=Sophos;i="4.43,337,1246838400"; 
   d="scan'208";a="193374736"
From: Roland Dreier <rdreier@cisco.com>
To: Greg KH <gregkh@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [BUG] git 2.6.31-rc3'ish: "<kobject> does not have a release() function, it is broken and must be fixed."
References: <20090716181256.GA11157@rhlx01.hs-esslingen.de>
	<20090716225525.GC1548@suse.de> <adabpmsg01a.fsf@cisco.com>
	<20090806205019.GA12988@rhlx01.hs-esslingen.de>
	<20090806223205.GD14792@suse.de>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 06 Aug 2009 16:47:31 -0700
In-Reply-To: <20090806223205.GD14792@suse.de> (Greg KH's message of "Thu, 6
	Aug 2009 15:32:05 -0700")
Message-ID: <adaiqh0ec8c.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Aug 2009 23:47:32.0218 (UTC) FILETIME=[43FE45A0:01CA16F0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Kay, we were cleaning up the kobject name stuff then, and we thought
 > that this release function wasn't used anymore.  But in looking at the
 > code, I can't see where the kobject is actually freed.  What am I
 > missing?

the kobject in question is freed at

  free_module() ->
    mod_kobject_remove() ->
      mod_sysfs_fini() ->
        kobject_put(&mod->mkobj.kobj);

(in kernel/module.c)

Of course the release function you removed in 7a6a4161 was empty so it
wasn't doing anything except satisfying the "all kobjects must have a
release method" diktat.

 - R.

