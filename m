Return-Path: <linux-kernel-owner+w=401wt.eu-S1758277AbZC0Mxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277AbZC0Mxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZC0Mx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:53:27 -0400
Received: from smtp.nokia.com ([192.100.122.233]:53092 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbZC0Mx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:53:26 -0400
Message-ID: <49CCCB0A.6070701@nokia.com>
Date: Fri, 27 Mar 2009 14:48:10 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: EXT4-ish "fixes" in UBIFS 
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 Mar 2009 12:48:11.0750 (UTC) FILETIME=[4996E860:01C9AEDA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

UBIFS has exactly the same properties like ext4 - in case
of power cuts:

1. truncate/write/close leads to empty files
2. create/write/rename leads to empty files

UBIFS is used in hand-held and and power-cuts are very
often there, because users just remove battery often.

I realize the "reality is different" argument, and already
concluded that we need a similar changes as Theo has done
for ext4:
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=bf1b69c0db7f9b9d8f02e94d40b19fca8336b991
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=f32b730a69bd56c5c9d704d8b75f03e90e290971
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=commitdiff;h=8411e347c3306ed36b8ca88611bf5fbf4d27d705

We have a problem that user-space people do not want to
use 'fsync()', even when they are pointed to their code
which is doing create/write/rename/close without fsync().

They just say - this is file-system bug, it is fixed in
ext4 now, just fix the bug in UBIFS.

I tell them, that is not a fix, that is band-aid, because
ext4 issues asynchronous write, and a power cut can lead
to corruptions anyway.

I tell them, we can make this in UBIFS, but please, anyway
add fsync() to your application. They say - now, we will
will not - you fix your UBIFS.

And because there is so much flood and about this, it is
so difficult to have reasonable arguments. I want to say
people - please, still use fsync(), if this is about the
performance/reliability trade-off - make it optional.
But they instead say - respected people are on our side,
go away. And point me this:
http://www.advogato.org/person/mjg59/diary/195.html
http://thread.gmane.org/gmane.linux.kernel/811167/focus=811700
http://article.gmane.org/gmane.comp.lang.perl.perl5.porters/67352

And they say that BTRFS and XFS are going to fix userspace
as well, and point me at this:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/317781/comments/175

This all became so messy and controversial. What should I do
to persuade userspace to use 'fsync()' even if we hack UBIFS
similarly to ext4? Suggestions?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
