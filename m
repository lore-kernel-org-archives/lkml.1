Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZLCHHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZLCHHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbZLCHHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:07:42 -0500
Received: from eagle.jhcloos.com ([207.210.242.212]:3506 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbZLCHHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:07:42 -0500
X-Greylist: delayed 661 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 02:07:42 EST
From: James Cloos <cloos@jhcloos.com>
To: Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: host a git archive on an rsync server?
In-Reply-To: <20091130082032.GS10640@bicker> (Dan Carpenter's message of "Mon,
	30 Nov 2009 10:20:32 +0200")
References: <20091130082032.GS10640@bicker>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Thu, 03 Dec 2009 01:44:43 -0500
Message-ID: <m3fx7s8sjw.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:30:091203:error27@gmail.com::7WWQVu71O8cr8eO0:0000000000000000000000000000000000000000000HB3al
X-Hashcash: 1:30:091203:linux-kernel@vger.kernel.org::UPCXZxQwL9wdZM1H:00000000000000000000000000000000/ZbIA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <error27@gmail.com> writes:

Dan> Could someone do a git clone and put it on an rsync server for me?

You can rsync the bare repo from kernel.org at:

rsync://rsync.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

After you get the rsync of the bare tree, do:

git clone --reference linux-2.6.git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

then you can delete the linux-2.6/.git/objects/info/alternates file and
copy the linux-2.6.git/objects/ tree to linux-2.6/.git/objects/.

(Making the separate clone and moving over the referenced objects is the
best way to ensure that the resulting repo has the same settings as a
direct clone would have.  You may want to run a git gc after all of that
to pack any loose objects from the rsync'ed repo.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
