Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYDJGPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYDJGPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 02:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbYDJGPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 02:15:09 -0400
Received: from main.gmane.org ([80.91.229.2]:41275 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYDJGPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 02:15:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Data corruption on software RAID
Date: Thu, 10 Apr 2008 08:14:36 +0200
Organization: Technische Universitaet Ilmenau, Germany
Message-ID: <ftkb92$r4n$1@ger.gmane.org>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4fd56835.dip.t-dialin.net
User-Agent: slrn/pre0.9.9-97 (Debian)
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz> wrote:
> During source code review, I found an unprobable but possible data 
> corruption on RAID-1 and on DM-RAID-1. (I'm not sure about RAID-4,5,6).
>
> The RAID code was enhanced with bitmaps in 2.6.13.
...
> The developers assume that when all writes to the region finish, the 
> region is in-sync.

Just for the records: You don't need bitmaps for that, this happens on
plain non-bitmapped devices as well.
I had an interesting discussion about this with Heinz Mauelshagen on the
linux-raid list back in early 2006 starting with
	Message-ID: <du6t39$be5$1@sea.gmane.org>

And it's not that unlikely at all. I experience such inconsistencies
regularly on ext2/3 filesystems with heavy inode fluctuations (for
example via cp -al; rsync, like rsnapshot does). I periodically sync
these inconsistencies manual. However, it always seems to appear with
inode removal only, which is rather harmless.


regards
   Mario
-- 
I've never been certain whether the moral of the Icarus story should
only be, as is generally accepted, "Don't try to fly too high," or
whether it might also be thought of as, "Forget the wax and feathers
and do a better job on the wings."            -- Stanley Kubrick

