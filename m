Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZCVRWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZCVRWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 13:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZCVRWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 13:22:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:54343 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZCVRWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 13:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=IQ/c5gqvoR03X6SNnVAu3ybyatRAf8u0r1NOAeu30IE1qRuAH2vWZwF+etUrVboRAa
         jYDJoeelpj5bXPI0IKUMIDcv0+xmVLfBHChfeD4leiILTq8QEKPebrre2BdjVm2Vq3Px
         D0jfjt1x7q5R7KN8CfNv2z09LKdADqGFd9fmc=
MIME-Version: 1.0
In-Reply-To: <20090319200931.GA10491@skl-net.de>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192021.20375.69678.stgit@dwillia2-linux.ch.intel.com>
	 <20090319200931.GA10491@skl-net.de>
Date: Sun, 22 Mar 2009 10:22:05 -0700
X-Google-Sender-Auth: d635748e9efa2317
Message-ID: <e9c3a7c20903221022v6049a74fu89b5032322343f25@mail.gmail.com>
Subject: Re: [PATCH 01/13] md/raid6: move raid6 data processing to raid6_pq.ko
From: Dan Williams <dan.j.williams@intel.com>
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
       maciej.sosnowski@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 1:09 PM, Andre Noll <maan@systemlinux.org> wrote:
> On 12:20, Dan Williams wrote:
>> Move the raid6 data processing routines into a standalone module
>> (raid6_pq) to prepare them to be called from async_tx wrappers and other
>> non-md drivers/modules.  This precludes a circular dependency of raid456
>> needing the async modules for data processing while those modules in
>> turn depend on raid456 for the base level synchronous raid6 routines.
>>
>> To support this move:
>> 1/ The exportable definitions in raid6.h move to include/linux/raid/pq.h
>
> As raid*.h and md.h have been moved to drivers/md recently, pq.h
> should probably live there as well.

Not in this case.  pq.h is analogous to xor.h currently in
include/linux/raid/.  I.e. just the data processing symbols that are
used by modules outside of drivers/md/.

>> +#define time_before(x, y) ((x) < (y))
>
> This macro seems to have no users (and a strange name).
>

It's used a few lines down in the same file.  It allows raid6algos.c
to be compiled for the userspace test (drivers/md/raid6test/) where we
do not have jiffies.h.

Regards,
Dan
