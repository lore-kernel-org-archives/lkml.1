Return-Path: <linux-kernel-owner+w=401wt.eu-S1758911AbYJ3Sci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911AbYJ3Sci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYJ3Sc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:32:26 -0400
Received: from smtp1.riverbed.com ([206.169.144.12]:2036 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758837AbYJ3ScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:32:25 -0400
Date: Thu, 30 Oct 2008 11:32:24 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ext3: slow symlink corruption on umount...
Message-ID: <20081030183224.GB8333@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081030174057.GB7926@ajones-laptop.nbttech.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric, ...

On Thu, Oct 30, 2008 at 10:40:57AM -0700, Arthur Jones wrote:
> [...]
> return 2 at the top of write_cache_pages().  In the working
> case, bdi_write_congested() returns 0 and the inodes are
> found twice in the s_io list in generic_sync_sb_inodes,
> first as i_state==7, where they are skipped, then a second
> time as i_state==4, where ->writepage() is then called...

To clarify, they are not on the list twice, rather
a separate call to generic_sync_sb_inodes sees them
again as i_state==4...

Arthur
