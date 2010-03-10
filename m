Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab0CJFIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:08:39 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:65397 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab0CJFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:08:36 -0500
To: Karel Zak <kzak@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Mike Snitzer <snitzer@redhat.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
	<170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
	<4B95F071.3070400@msgid.tls.msk.ru>
	<20100309100153.GD18077@nb.net.home>
	<4B961FE1.5040105@msgid.tls.msk.ru>
	<20100309121858.GA2020@nb.net.home>
Date: Wed, 10 Mar 2010 00:06:25 -0500
In-Reply-To: <20100309121858.GA2020@nb.net.home> (Karel Zak's message of "Tue,
	9 Mar 2010 13:18:59 +0100")
Message-ID: <yq1iq947oku.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B972940.012F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Karel" == Karel Zak <kzak@redhat.com> writes:

[Cleaned up the CC: list from hell]

Karel>  # cat /sys/block/md8/queue/{minimum,optimal}_io_size
Karel>  65536 65536

This one had me puzzled.  We set min_io and opt_io correctly in raid5.c
depending on number of non-parity disks.  And yet it turns into
something nonsensical after.

Turns out we overrun unsigned int calculating the lowest common multiple
in the stacking function.  That's why we ended up with the wrong value.

I never noticed this because my userland topology regression test tool
uses unsigned long.

I'll get a patch off to Jens right away.

-- 
Martin K. Petersen	Oracle Linux Engineering
