Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbZAMNO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbZAMNO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbZAMNOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:14:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZAMNOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:14:19 -0500
Date: Tue, 13 Jan 2009 14:14:18 +0100
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz, tytso@mit.edu
Subject: ext2 + -osync: not as easy as it seems
Message-ID: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I tried to use ext2+ -osync, and was surprised that my data do not hit
the (SATA) disk. Fortunately I soon realized that I need hdparm -W0
/dev/sda.

Could the ext2 be teached to use barriers? -W0 hurts performance more
than neccessary...

Plus it has a nasty behaviour where it reverts to -W1 if disk
connection is momentarily lost. (If you unplug/replug SATA disk, linux
will happily rediscover and use it, but -W0 was already forgotten at
that point, right?)
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
