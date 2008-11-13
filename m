Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYKMP4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYKMP4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 10:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYKMPzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 10:55:52 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:26658 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYKMPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 10:55:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QAP3aLkt9vXVJ7ZMAS4v1UYqNNMAAqSzrEOFfCtgbqVg8U0V5KBCePWilULd4DWUV5
         D0jFSumjeWLBGRNc+z8mR4nQmgSDB1A7RPqTJHhgScUE3l5tQSxMDp+t/gDjV1nPO6K7
         7BtD7vT1uE2/rgvWr3tRLlu4wmSTju6WbroSs=
Message-ID: <8bd0f97a0811130755t1e75b5b9tbdcf5189feea8b38@mail.gmail.com>
Date: Thu, 13 Nov 2008 10:55:49 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Atsushi Nemoto" <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] mtd: unify mtd partition/device registration
Cc: vapier@gentoo.org, linux-mtd@lists.infradead.org, dwmw2@infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081114.005132.78730934.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081113.224350.18312549.anemo@mba.ocn.ne.jp>
	 <20081113.232823.125897716.anemo@mba.ocn.ne.jp>
	 <8bd0f97a0811130651k11c52a53j91c80cf196e9f66a@mail.gmail.com>
	 <20081114.005132.78730934.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 10:51, Atsushi Nemoto wrote:
> On Thu, 13 Nov 2008 09:51:01 -0500, "Mike Frysinger" wrote:
>> > Automatic fallback to mtd_device in parse_mtd() is convenient but
>> > somewhat unflexible...
>>
>> we could just have it do it all the time.  i dont see a problem with
>> exposing the entire block device the whole time ?  i know for the
>> driver or two of mine, i'm fine with it.
>>
>> ...
>>        ret = parse_mtd_partitions(mtd, probe_types, &parts, 0);
>>        if (ret > 0) {
>>                ret = add_mtd_partitions(mtd, parts, ret);
>>                kfree(parts);
>>        } else if (nr_parts)
>>                ret = add_mtd_partitions(mtd, parts, nr_parts);
>>        if (ret)
>>                return ret;
>> #endif
>>
>>        return add_mtd_device(mtd);
>
> I'm OK with this.  But not sure all current mtd partition users.
>
> Are you going to convert all parse_mtd_partitions() call?  Maybe some
> people do not want to change /dev/mtd numbers...

if it's a real concern, we can make it optional.  i'll post patches to
convert physmap and my drivers as those are the only ones i can
actually test.
-mike
