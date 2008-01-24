Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbYAXRcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbYAXRcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 12:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYAXRc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 12:32:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:59460 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbYAXRc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:32:26 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC] Parallelize IO for e2fsck
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andreas Dilger <adilger@sun.com>,
       Valdis.Kletnieks@vt.edu, David Chinner <dgc@sgi.com>,
       Valerie Henson <val@vahconsulting.com>, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@clusterfs.com>,
       Ric Wheeler <ric@emc.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 24 Jan 2008 18:32:15 +0100
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+ZTtNUKJmpb/gHfQxy/LqjPReXpNLBIlobg9D
 9uHkCxw2l2XlqK9AJEoW33PQ8qkz/TPD5FoiDR88Xjras9R4Hc
 jlUM3k4TET55sD6yQJnYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

>> I'd tried to advocate SIGDANGER some years ago as well, but none of
>> the kernel maintainers were interested.  It definitely makes sense
>> to have some sort of mechanism like this.  At the time I first brought
>> it up it was in conjunction with Netscape using too much cache on some
>> system, but it would be just as useful for all kinds of other memory-
>> hungry applications.
> 
> There is an early thread for a /proc file which you can add to your
> poll() set and it will wake people when memory is low. Very elegant and
> if async support is added it will also give you the signal variant for
> free.

IMO you'll need a userspace daemon. The kernel does only know about the
amount of memory available / recommended for a system (or container),
while the user knows which program's cache is most precious today.

(Off cause the userspace daemon will in turn need the /proc file.)

I think a single, system-wide signal is the second-to worst solution: All
applications (or the wrong one, if you select one) would free their caches
and start to crawl, and either stay in this state or slowly increase their
caches again until they get signaled again. And the signal would either
come too early or too late. The userspace daemon could collect the weighted
demand of memory from all applications and tell them how much to use.

