Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZAJGLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZAJGLo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 01:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZAJGLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 01:11:36 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:47905 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJGLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 01:11:35 -0500
X-IronPort-AV: E=Sophos;i="4.37,243,1231113600"; 
   d="scan'208";a="127245595"
From: Roland Dreier <rdreier@cisco.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Fix register_disk() when name has '/' in it
References: <adaljtjog90.fsf@cisco.com>
	<ac3eb2510901092208q1bbaca38xc1aefa9247b86f42@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Jan 2009 22:11:34 -0800
In-Reply-To: <ac3eb2510901092208q1bbaca38xc1aefa9247b86f42@mail.gmail.com>
	(Kay Sievers's message of "Sat, 10 Jan 2009 07:08:01 +0100")
Message-ID: <adahc47ofl5.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Jan 2009 06:11:34.0862 (UTC) FILETIME=[4A24F6E0:01C972EA]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Commit 3ada8b7e ("block: struct device - replace bus_id with dev_name(),
 > > dev_set_name()") deleted the code in register_disk() that changed a '/'
 > > to a '!' in the device name when registering a disk.
 > 
 > Hmm, this is done in the core, for all devices since a while:
 >   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9f255651fb41c111ee35a2ae632df8ce9bd61def
 > 
 > We should find what is going wrong here, instead of putting that code back.

The commit you point to is for kobject_set_name() ... but dev_set_name()
is still just setting dev->bus_id (at least in Linus's current tree).

If you want I can send a patch putting the conversion into
dev_set_name() for now instead.

 - R.
