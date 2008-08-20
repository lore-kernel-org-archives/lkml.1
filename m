Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYHTQxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYHTQxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbYHTQxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:53:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37659 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYHTQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:53:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=R9ec/D/EBrKBtPndg7xrZDsGxDOXrx8khRdL/mUpNqwV95ZCmmgQvwtUlmlqzqO/FJ
         k+NzwVadQ3gikPxyTLuTW1YFD3QiFeGQh0r1V2MtJOWuSelU3Lo4lbdwRmxcMBqh1ojp
         UP7fUMv2y8NC299qoSQ0Dhn8G6w6HKLwVr1J8=
Message-ID: <48AC4B19.6000206@gmail.com>
Date: Wed, 20 Aug 2008 18:49:29 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       Davide Libenzi <davidel@xmailserver.org>
Subject: No NONBLOCK flag for dup3() or epoll_create1()?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich

I've been doing some testing (2.6.27-rc3) of your new
file-descriptor-creating syscalls that accept flags.  According to

http://udrepper.livejournal.com/20407.html

all of the system calls should accept a *_NONBLOCK flag.  All of them do,
except for two:
dup3(olfd, newfd, flags)
and
epoll_create1(flags).

For epoll_create1() this certainly appears to be an oversight, since I can't
think of a reason not to support *_NONBLOCK.

For dup3() it is perhaps also an oversight.  However, it's not really clear
to me whether supporting O_NONBLOCK makes sense, since that would change the
file status flags of the open file description that is (also) referred to by
oldfd.  (Furthermore, given a open file description for which O_NONBLOCK is
already enabled, it is not possible to make a dup3() call that disables
O_NONBLOCK, which is an odd asymmetry in the API.)  What are your thoughts on
this?

Cheers,

Michael

