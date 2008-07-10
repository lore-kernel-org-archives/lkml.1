Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbYGJX7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbYGJX7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbYGJX7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:59:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYGJX7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:59:05 -0400
Date: Thu, 10 Jul 2008 19:57:41 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Julian Calaby <julian.calaby@gmail.com>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <646765f40807101559q51fbfc50x8e3466e5f202e0c8@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0807101953270.26084@engineering.redhat.com>
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
 <646765f40807101559q51fbfc50x8e3466e5f202e0c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Julian Calaby wrote:

> On Fri, Jul 11, 2008 at 07:56, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> Hi
>>
>> I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had to fix
>> the endianity issues in the driver, but that's unrelated).
>>
>> When I examined the crashes, it turned out that SCSI layer passed requests
>> with too many segments. The controller has at most 32 SG entries per
>> request. It sets shost->sg_tablesize to 32, but despite this, larger
>> requests were submitted to it --- this resulted in overwriting random memory
>> and crashes.
>
> [snip]
>
> Should this have been CC'd to linux-scsi too? This sounds like it
> could be a bug at their end.
>
> Thanks,
>
> -- 
> Julian Calaby

This is not a bug in scsi layer, those "nr_hw_segments" miscalculations 
are hapenning in block/blk-merge.c and they can show up with any block 
device driver that has small number of SG entries.

But I can CC it there, just for their information.

Mikulas
