Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbYDNQyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbYDNQyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYDNQx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:53:59 -0400
Received: from styx.suse.cz ([82.119.242.94]:59234 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754988AbYDNQx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:53:58 -0400
Date: Mon, 14 Apr 2008 18:53:54 +0200
From: Jan Kara <jack@suse.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Bodo Eggert <7eggert@gmx.de>, Diego Calleja <diegocg@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
       Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
Message-ID: <20080414165354.GF15824@duck.suse.cz>
References: <agh4d-6yc-35@gated-at.bofh.it> <ah5tY-3lR-7@gated-at.bofh.it> <ah5DA-3X9-9@gated-at.bofh.it> <ah5X5-4tl-13@gated-at.bofh.it> <ah66A-4Nk-7@gated-at.bofh.it> <ah7vN-7Wz-9@gated-at.bofh.it> <E1JkIJ0-0000tG-LV@be1.7eggert.dyndns.org> <20080411135544.GG2160@csclub.uwaterloo.ca> <20080414162031.GD15824@duck.suse.cz> <20080414162202.GB7387@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414162202.GB7387@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 14-04-08 12:22:02, Lennart Sorensen wrote:
> On Mon, Apr 14, 2008 at 06:20:31PM +0200, Jan Kara wrote:
> >   Well, as Jiri Kosina wrote, this isn't a problem unless someone finds
> > a way how to use this race for some attack (and for example making f_pos
> > negative compromises security so it is not so far-fetched as it would
> > seem). So proactively fixing this makes some sence.
> 
> But you would have to be part of that process to affect the filehandle
> wouldn't you?  If you are part of the process already wouldn't it be
> easier to manipulate things directly rather than playing with the
> filehandle position?
  Well, but imagine you have a file /proc/my_secret_file from which you
are able to read from position A:a and B:b but not from position
A:b. Concievably, checks for the file position could be bypassed because of
this race... I know this is kind of dumb example but I can imagine someone
can eventually find something like this. So I guess one spin lock/unlock
pair is a price worth paying in the callpath which is quite long anyway.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
