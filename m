Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYHNRHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYHNRHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYHNRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:07:32 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:3207 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYHNRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:07:31 -0400
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 13:07:31 EDT
From: James Cloos <cloos@jhcloos.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>
Subject: Would it be better for git-commits-head to have -M -C diffs?
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2008 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Thu, 14 Aug 2008 12:56:18 -0400
Message-ID: <m3ljyzsfg6.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Hashcash: 1:23:080814:linux-kernel@vger.kernel.org::fvJXZg9WYE5BycT2:000000000000000000000000000000000aYdA
X-Hashcash: 1:23:080814:dwmw2@infradead.org::c0ewPTr3GiWL6Sdj:0000000000000000000000000000000000000000008PWG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Would anyone else prefer to see the posts on the commits list use git's
copy and move detection?

Git show (used by the feed-mail-list script) does support -M and -C.

It does affect the stat section.  The recent commit 758db3f21187 would
have had its stat changed from looking like:

 arch/h8300/include/asm/Kbuild              |    1 +
 arch/h8300/include/asm/a.out.h             |   20 ++
 arch/h8300/include/asm/atomic.h            |  144 +++++++++++
                        .
                        .
                        .
 include/asm-h8300/Kbuild                   |    1 -
 include/asm-h8300/a.out.h                  |   20 --
 include/asm-h8300/atomic.h                 |  144 -----------
                        .
                        .
                        .

to looking like:

 .../asm-h8300 => arch/h8300/include/asm}/Kbuild    |    0 
 .../asm-h8300 => arch/h8300/include/asm}/a.out.h   |    0 
 .../asm-h8300 => arch/h8300/include/asm}/atomic.h  |    0 
 .../asm-h8300 => arch/h8300/include/asm}/auxvec.h  |    0 
 .../asm-h8300 => arch/h8300/include/asm}/bitops.h  |    0 
 .../h8300/include/asm}/bootinfo.h                  |    0 
                        .
                        .
                        .

but would have been 512 lines and 24271 octets instead of 10623 lines
and 291634 octets.

I think it would also be useful were the From: header of each message
set to the commit's Author.  I run each commit through a script to do
that locally, but the archives would also benefit from that.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
