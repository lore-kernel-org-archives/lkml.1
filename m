Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbYFDKyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbYFDKyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760000AbYFDKyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:54:03 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49219 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbYFDKyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:54:00 -0400
X-AuditID: 0ac90650-ac68cba0000062df-40-484674460f80
Message-ID: <4846743C.5060400@hitachi.com>
Date: Wed, 04 Jun 2008 19:53:48 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: sct@redhat.com, adilger@clusterfs.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz, jbacik@redhat.com,
       cmm@us.ibm.com, tytso@mit.edu, yumiko.sugita.yf@hitachi.com,
       satoshi.oshima.fk@hitachi.com
Subject: Re: [PATCH 1/5] jbd: strictly check for write errors on data buffers
References: <4843CE15.6080506@hitachi.com> <4843CEED.9080002@hitachi.com> 
    <20080603153050.fb99ac8a.akpm@linux-foundation.org>
In-Reply-To: <20080603153050.fb99ac8a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:

> On Mon, 02 Jun 2008 19:43:57 +0900
> Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com> wrote:
> 
>>In ordered mode, we should abort journaling when an I/O error has
>>occurred on a file data buffer in the committing transaction.
> 
> Why should we do that?

Aborting the journal leads the filesystem to read-only state, and it
can prevent inconsistent state in file data from diffusing furthermore. 
I think it makes sense for ordered mode users; they don't want to
lose file updates as much as possible, but they don't want to do fsync.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

