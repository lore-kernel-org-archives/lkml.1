Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYIUCBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYIUCBs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 22:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbYIUCBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 22:01:39 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39364 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYIUCBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 22:01:38 -0400
To: "Dan Williams" <dan.j.williams@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com,
       neilb@suse.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: Add support for data integrity to MD
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <yq1y71mmjvw.fsf@sermon.lab.mkp.net>
	<e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com>
Date: Sat, 20 Sep 2008 22:01:29 -0400
In-Reply-To: <e9c3a7c20809201726v78f9a00gb9a168f7f9c19044@mail.gmail.com> (Dan Williams's message of "Sat\, 20 Sep 2008 17\:26\:40 -0700")
Message-ID: <yq1ljxmmf46.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Dan" == Dan Williams <dan.j.williams@gmail.com> writes:

>> + /* Data integrity passthrough not supported on RAID 4, 5 and 6 */
>> + if (pers->level >= 4 && pers->level <= 6) + return 0;

Dan> Do you have a reference to the issues in supporting this?

Not really.

The protection information is an extra 8-bytes of stuff per sector.
But it comes down in a different buffer.  To do R-M-W effectively
we'll have to maintain a separate protection information stripe cache.
And we'll have to generate DIF checksums and reference tags for the
parity sectors going out.

Quite frankly it's a lot of ick and I haven't completely wrapped my
head around it yet.

-- 
Martin K. Petersen	Oracle Linux Engineering

