Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYIRBMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYIRBMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 21:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbYIRBL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 21:11:56 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36662 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYIRBLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 21:11:55 -0400
Message-ID: <48D1AA84.3050603@oss.ntt.co.jp>
Date: Thu, 18 Sep 2008 10:10:28 +0900
From: Kazuo Ito <ito.kazuo@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: dm-devel@redhat.com, jblunck@suse.de, kjamieson@bycast.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-snapshot: poor copy-on-write performance due to I/O
 reordering
References: <bd0gX-4ma-13@gated-at.bofh.it> <E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
In-Reply-To: <E1KfzFv-00041e-8A@be1.7eggert.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Bodo Eggert wrote:
> Kazuo Ito <ito.kazuo@oss.ntt.co.jp> wrote:
> 
>> Write throughput to LVM snapshot origin volume is an order
>> of magnitude slower than those to LV without snapshots or
>> snapshot target volumes, especially in the case of sequential
>> writes with O_SYNC on.
>>
>> The following patch originally written by Kevin Jamieson and
>> Jan Blunck and slightly modified for the current RCs by myself
>> tries to improve the performance by modifying the behaviour
>> of kcopyd, so that it pushes back an I/O job to the head of
>> the job queue instead of the tail as process_jobs() currently
>> does when it has to wait for free pages. This way, write
>> requests aren't shuffled to cause extra seeks.
> 
> Did you check for starvation problems, too?

I ran sadc along with the tests and figures like
%memused, kbbuffers and kbcached didn't change much
before and after the patch.  And since the buffered I/O
results didn't deteriorate at least in the cases of
10 and 100 megabyte sequential writes, I assumed
there should be plentiful of memory for the kernel
to use at least in these cases.

Anyway I can send you more detailed info upon your request.

Regards,

Kazuo Ito, NTT Open Source Software Center
Phone: +81-3-5860-5125 / FAX: +81-3-5463-5690 / E-mail: ito.kazuo@oss.ntt.co.jp
