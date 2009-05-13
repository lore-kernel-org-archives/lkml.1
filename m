Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbZEMROR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbZEMROR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 13:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759904AbZEMRN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 13:13:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:47656 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759162AbZEMRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 13:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=pHshilKWfP+lPUr/p1Eth5ADya4VoYQm4705rWgPrTfEgPjHel1N6W/bm0/k/no/sl
         RvUpStrmXlLTjYjxj5sznllQtiPrMQ3iLinOTVXJQIAn7F9WYe00D45HX63l8XmJ4TG/
         TK1jtdfX3banWnur0oUcyrMNcIBmLzXdK5Ubs=
MIME-Version: 1.0
Date: Wed, 13 May 2009 13:13:58 -0400
Message-ID: <d978a99e0905131013p645317dfy2747b531e550ba9d@mail.gmail.com>
Subject: filesystem with integrity checking
From: crimil tradalo <crimiltradalo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking for a filesystem that supports integrity checking of
files with some kind of checksum/hash.

For example, for each block an SHA hash is stored when written and
verified when read. If the underlying hardware has corrupted the data,
or returned a different block than expected, the filesystem can detect
the error.

Obviously, ideal would be integration with the RAID layer so that
valid data could be found in the redundancy, similar to ZFS, but I
don't expect this to exist.

The last time I saw this discussed, the consensus seemed to be that it
wasn't worth the CPU time. I hope that as CPUs have gotten faster and
data sets larger, more people are noticing how frequent data
corruption occurs and are beginning to respect the value of an OS
ensuring the integrity of data on permanent storage. Everyone here
must have experienced data corruption that is either seemingly-random
or traced to bad hardware. I'd like to detect such corruption as soon
as it happens, rather than after it has caused a catastrophic loss of
data.

If there is none that currently supports this, I am curious if any
intend to support it eventually. I see it mentioned in BTRFS
documentation, but considering the low odds of a new filesystem
actually becoming viable, I'm more interested in a practical solution.

My understanding is that the only filesystems that offer this are ZFS
and WAFL, neither of which is going to be useful on Linux of course.
