Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYFYBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYFYBnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYFYBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 21:43:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56981 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYFYBnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 21:43:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: Oops when using growisofs
Date: Wed, 25 Jun 2008 03:42:08 +0200
User-Agent: KMail/1.9.9
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@ucw.cz>
References: <200806221818.24372.mb@bu3sch.de> <20080624172812.GD22586@atrey.karlin.mff.cuni.cz> <200806242039.18755.mb@bu3sch.de>
In-Reply-To: <200806242039.18755.mb@bu3sch.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806250342.08575.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19s7z4lhlTBxdol0vyFEd2Nq8s+lz7OgmQRX0M
 wgpB+tK41efnwgIol2aDBVU0ycujcxNjpNvhjra45VN4Vk/Yg+
 9xOA6lNhOv/o9vHu6EHag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2008, Michael Buesch wrote:
> >   I have seen one more report of this Oops for SLES10 kernel and also in that
> > case an IO error happened so probably that is a trigger... But so far I
> > don't get the details.
> 
> Yeah the IO error is the trigger.
> I noticed that it had obvious troubles accessing the DVD that was in the drive.
> It sweeped over it for several seconds, then hung the system for 2 or 3 seconds
> and then oopsed. But after that everything continued to work as usual.
> (Except kded of course)

So maybe a use-after-free bug in the I/O error handling caused an inode to
be overwritten and then passed to an I/O function that used an invalid
inode->i_blkbits?

	Arnd <><
