Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbXBXNP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbXBXNP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932737AbXBXNP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:15:29 -0500
Received: from mail.clusterfs.com ([206.168.112.78]:35007 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbXBXNP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:15:28 -0500
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17888.14958.85897.289141@gargle.gargle.HOWL>
Date: Sat, 24 Feb 2007 16:15:26 +0300
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, miklos@szeredi.hu,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com
Subject: Re: [RFC][PATCH 0/3] VM throttling: avoid blocking occasional writers
Newsgroups: gmane.linux.kernel
In-Reply-To: <45DED819.9040404@hitachi.com>
References: <45DED819.9040404@hitachi.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000385 765636f27692906b574fb20735aeae11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomoki Sekiyama writes:
 > Hi,

Hello,

 > 

[...]

 > 
 > While Dirty+Writeback pages get more than 40% of memory, process-B is
 > blocked in balance_dirty_pages() until writeback of some (`write_chunk',
 > typically = 1536) dirty pages on disk-b is started.

May be the simpler solution is to use separate variables to control
ratelimit and write chunk?

writeback_set_ratelimit() adjusts ratelimit_pages to avoid too frequent
calls to balance_dirty_pages(), but once we are inside of
writeback_inodes(), there is no need to write especially many pages in
one go: overhead of any additional looping is negligible, when compared
with the cost of writing.

Speaking of which, now that expensive get_writeback_state() is gone from
page-writeback.c why do we need adjustable ratelimiting at all? It looks
like writeback_set_ratelimit() can be dropped, and fixed ratelimit used
instead.

Nikita.

