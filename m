Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXLHLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXLHLnr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 06:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbXLHLnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 06:43:39 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:62296 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXLHLni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 06:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=aJo3FD3jtsMBFRKLXClYalY7HqAsF+YIechTom7XCysR9Xsg1ZeJii8sENmxPCycTn4z5UnrW3wqfx9m/u5gauu0bW+7Gqu1V4T45qp5PR4C+44hJ3sZrW1AQvF7pw2vsUyAj2cKaQEWaTARomemjc+mlbWQ3N2717qhNbFqsw8=
Message-ID: <817d11390712080343v54bff28j8a08299f445b6905@mail.gmail.com>
Date: Sat, 8 Dec 2007 13:43:37 +0200
From: "T T" <gentuu.call@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Quotaon livelock
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

Enabling FS quotas can take up to several minutes to finish and
depends on other users disk activity. This makes it a livelock (as it
can be finished anyway).

The problem described at:
http://bugzilla.kernel.org/show_bug.cgi?id=9520

Yes, if we need to enable quotas once in the system start - no problem.
But if we have to disable/enable it periodically - this become a nightmare.

Please don't advice to use edquota or so (quotactl(Q_SETQUOTA...) based things).
What if it's really needed to use quotactl(Q_QUOTAOFF...)/quotactl(Q_QUOTAON...)

The problem is at fs/dquot.c:add_dquot_ref()
It's restarting to loop over the inodes list once it inits quota on an inode.
And this happens over and over if something is modifying inodes list
during quotas enabling.

It looks like the action must take some time depending on FS size, but
not on other users
disk activity...
Any advices how the algorithm at fs/dquot.c:add_dquot_ref() can be enhanced?

Thanks
Nick
