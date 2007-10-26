Return-Path: <linux-kernel-owner+w=401wt.eu-S1763157AbXJZD5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763157AbXJZD5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 23:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbXJZD5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 23:57:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:65040 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbXJZD5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 23:57:17 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux machines dieing in swap storms
To: Rik van Riel <riel@redhat.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 26 Oct 2007 05:56:49 +0200
References: <9icP2-2hb-17@gated-at.bofh.it> <9ifML-6Xs-25@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IlGJV-0007vW-A6@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19IZAZ36yiKImQs7v7ujtXVSpdTqu7FhqXUXWH
 pByRksdlirtBYFsQsJ9rKcuYF3CrC9FF4LeM9RnQCouu41R9ua
 ndqb8722PaxumlX3/c6qA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel <riel@redhat.com> wrote:
> On Thu, 25 Oct 2007 16:20:41 +0100
> Richard Purdie <rpurdie@rpsys.net> wrote:

>> Advice on solving this welcome preferably in mainline but I'll happily
>> hack my kernels with a workaround if need be.
> 
> I can't see any easy hacks or workarounds to fix the issue in the
> current MM, except maybe activate the OOM killer if the amount of
> page cache and buffer cache is really low and swap is full...
> 
> In the longer run, I'm working on:
> 
> http://linux-mm.org/PageReplacementDesign

What about only reclaimimn cache if the cache has grown beyond a watermark
and only reclaimimn non-cache if it's below another watermark? I can imagine
it will solve my diskcache-pushes-out-mousehandler problem, and I'm pretty
sure having very low file cache is bad for performance, too.

Another thing I can imagine is to detect thrashing conditions and to
change scheduling in order to increase the likehood of cache hits and
thereby progress: If an application just got a page, keep it running for
a while (accumulating negative credits).
-- 
"Of course, as admin, I can read all your email. But I am not THAT bored!"
        -- unknown author in comp.unix.aix

Friﬂ, Spammer: 9w@t.7eggert.dyndns.org gNhwn@wocz.7eggert.dyndns.org
