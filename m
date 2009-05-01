Return-Path: <linux-kernel-owner+w=401wt.eu-S1760488AbZEAV76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488AbZEAV76 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 17:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZEAV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 17:59:48 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56751 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbZEAV7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 17:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <20090501122625.a60ccbbe.akpm@linux-foundation.org>
References: <1241097822.2516.3.camel@poy> <20090430222900.c13b63d5.akpm@linux-foundation.org> 
	<ac3eb2510905010416q36c9e155ya4131cf82dfd13bc@mail.gmail.com> 
	<20090501122625.a60ccbbe.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 1 May 2009 23:59:32 +0200
Message-ID: <ac3eb2510905011459i6cbf1199ua0670b82097a0309@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, jblunck@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 21:26, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 1 May 2009 13:16:22 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> On Fri, May 1, 2009 at 07:29, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> > dev->type->nodename() might have failed due to -ENOMEM, in which case
>> > it seems wrong to assume that it returned NULL for <whatever reason you
>> > thought it might want to return NULL>.
>> >
>> > It's all a bit confused.
>>
>> This logic is only for providing a custom name hint. Only a few
>> devices need that at all. If the allocation fails, the default name
>> will be used, not the custom name.
>
> But that's bad, isn't it?  It means that the kernel will come up with
> one name if the memory allocation succeeded, and a different name if
> the allocation failed.

Yeah, sure, it's bad. But I think we have pretty much lost anyway, if
we run into oom at this stage.

What should we do instead? If we, for some reason, can not get a
possible custom name?

Thanks,
Kay
