Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYJ3Ve1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYJ3Ve1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbYJ3VeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:34:18 -0400
Received: from smtp2.riverbed.com ([206.169.144.7]:10710 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbYJ3VeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:34:17 -0400
Date: Thu, 30 Oct 2008 14:34:00 -0700
From: Arthur Jones <ajones@riverbed.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "sct@redhat.com" <sct@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ext3: slow symlink corruption on umount...
Message-ID: <20081030213400.GA28900@ajones-laptop.nbttech.com>
References: <20081024183733.GA25797@ajones-laptop.nbttech.com> <20081027165423.GB25797@ajones-laptop.nbttech.com> <20081029195403.GA8333@ajones-laptop.nbttech.com> <4908C951.2000309@redhat.com> <20081030174057.GB7926@ajones-laptop.nbttech.com> <4909F705.8090904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4909F705.8090904@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,  ...

On Thu, Oct 30, 2008 at 11:03:49AM -0700, Eric Sandeen wrote:
> [...]
> Something is definitely racy here; in my simple testcase I get failures
> maybe 30-50% of the time...

Some more info: in the working case, the inodes are put
back on sb->s_dirty at then next ext3_sync_fs() call:

__fsync_super -> DQUOT_SYNC -> ext3_sync_fs -> log_wait_commit

In the failing case, journal_start_commit returns 0 in ext_sync_fs
and the inodes disappear into never-never land...

Arthur
