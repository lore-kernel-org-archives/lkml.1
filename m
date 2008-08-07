Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYHGAra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYHGAra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbYHGArV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:47:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:40447 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYHGArT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=VhB8FOHDa5pPJBGgSV6NMQmjlG3h6NZgRLLHuGZjH/FwwMW/6VkbqLutROLRGAmSJX
         DEgR1J+qxuQNDlSSda0TDu6u7rIct8KwHDvswTZcT/2wnl6HCn5f0jtDmesi8iWKTYXH
         c64rsqEcRAzvim0IZOSjQDZE2x2+6u8OFTNJ0=
Message-ID: <e9e943910808061747x57dc2ed0s614785d9d0a087a8@mail.gmail.com>
Date: Thu, 7 Aug 2008 01:47:17 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Stephen C. Tweedie" <sct@redhat.com>
Subject: Re: [PATCH] jbd: abort instead of waiting for nonexistent transactions
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       "Sami Liedes" <sliedes@cc.hut.fi>
In-Reply-To: <1217951437.3886.36.camel@sisko.scot.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217893895-29165-1-git-send-email-duaneg@dghda.com>
	 <1217951437.3886.36.camel@sisko.scot.localnet>
X-Google-Sender-Auth: a9f1b5ad4f758425
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/5 Stephen C. Tweedie <sct@redhat.com>:
> On Tue, 2008-08-05 at 00:51 +0100, Duane Griffin wrote:
>> The __log_wait_for_space function sits in a loop checkpointing transactions
>> until there is sufficient space free in the journal. However, if there are
>> no transactions to be processed (e.g. because the free space calculation is
>> wrong due to a corrupted filesystem) it will never progress.
>>
>> Check for space being required when no transactions are outstanding and
>> abort the journal instead of endlessly looping.
>
> I'm not sure this is the right fix --- it seems like we're fixing the
> symptoms, not the problem.
>
> The journal free space fields are reset in journal_reset() when we load
> the journal, so we can't get this situation of j_free being insufficient
> on an idle filesystem unless the main journal start/end pointers are
> corrupt.
>
> Surely we'd be better off detecting this in the first place at mount
> time, not later on during checkpoint?

Sounds sensible. In fact I've got another patch, waiting for feedback
from the reporter, that adds some very basic validation there (i.e.
first > 0 && last >= first). Not enough, I suspect. I guess we could
do much better?

> Cheers,
>  Stephen

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
