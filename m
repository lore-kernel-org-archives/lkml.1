Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbXIQRVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbXIQRVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbXIQRVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 13:21:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015AbXIQRVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 13:21:45 -0400
Message-ID: <46EEB7A4.9040903@sandeen.net>
Date: Mon, 17 Sep 2007 12:21:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: ext4 development <linux-ext4@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       hooanon05@yahoo.co.jp, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] ext34: ensure do_split leaves enough free space in both
 blocks
References: <46EEA5F4.3030806@redhat.com>
In-Reply-To: <46EEA5F4.3030806@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> The do_split() function for htree dir blocks is intended to split a
> leaf block to make room for a new entry.  It sorts the entries in the
> original block by hash value, then moves the last half of the entries to 
> the new block - without accounting for how much space this actually moves.  
> (IOW, it moves half of the entry *count* not half of the entry *space*).
> If by chance we have both large & small entries, and we move only the 
> smallest entries, and we have a large new entry to insert, we may not have 
> created enough space for it.

(btw, the upshot of this is that in add_dirent_to_buf(),
memcpy(de->name, name, namelen) will overshoot the buffer and actually
corrupt memory.)

:(

-Eric
