Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbYILRJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbYILRJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 13:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYILRJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 13:09:38 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:64210 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYILRJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 13:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LfyD0kMrW+paOZMjAkTgY2ZJzCAWUjC2YDk5qev/w+LRuWzGN8eiI8y1DBJe7BYgr1
         aXNshguAAyOC/Gvns/JOx+Ivzl+CbReRFMlx/fpyrsHxOcDmK4wcVUtZjpjJrY/C0eZL
         PU9u+zA2nWFRGT4lP44QXoZKHtJl5mnj/qsAA=
Message-ID: <19f34abd0809121009o81f2705ve083209a4af23b5d@mail.gmail.com>
Date: Fri, 12 Sep 2008 19:09:35 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kmemcheck: lazy checking for MOVS instructions
Cc: linux-kernel@vger.kernel.org, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080912090607.GA6632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080911154616.GA16042@localhost.localdomain>
	 <20080912090607.GA6632@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 11:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Thu, 11 Sep 2008 17:31:07 +0200
>> Subject: [PATCH] kmemcheck: lazy checking for MOVS instructions
>>
>> This patch adds the support for lazy (as opposed to eager) checking
>> for [REP] MOVS instructions (mostly used in memcpy()). This means that
>> if both the source and destination addresses are tracked by kmemcheck,
>> we copy the shadow memory instead of checking that it is initialized.
>>
>> In this way, we get rid of a few more false positives.
>
> looks good to me. I've applied it to tip/kmemcheck - but can zap it and
> pull your for-tip branch as well.

Please zap, I believe it contains an error :-)

In short, when reading/writing the shadow memory of the second page in
a page-boundary-crossing memory access, the offsets into the second
shadow page will be wrong (off by up to 8 bytes). It's a pretty
obscure case, but it would be nice to have it fixed. Will send a pull
request later.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
