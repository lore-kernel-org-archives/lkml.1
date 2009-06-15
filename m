Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbZFOP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbZFOP1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762390AbZFOP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:27:09 -0400
Received: from mail-fx0-f207.google.com ([209.85.220.207]:48327 "EHLO
	mail-fx0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762374AbZFOP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SSnOb5jY8ZRYfR6nIKS6jC7/NP5grDqOAxLlATYcAQcgWXb8RsN9P/6X7tH8EZVsDl
         P2tvadkpfKyxQsPxggF9nSavPDfYMG5XD86Mq7GO1H0uMYZniTBWxqC1lk5Zt8fo/tLK
         DNTCQwIUvEw28O78kkP/6ASeFKaoUuc8smk3w=
MIME-Version: 1.0
In-Reply-To: <1245078661.23207.50.camel@penberg-laptop>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906121317140.23840@gentwo.org>
	 <Pine.LNX.4.64.0906141011280.8507@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906151051240.19931@gentwo.org>
	 <1245077891.23207.48.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906151101580.23995@gentwo.org>
	 <1245078661.23207.50.camel@penberg-laptop>
Date: Mon, 15 Jun 2009 18:27:08 +0300
X-Google-Sender-Auth: 3fc30e31fb1df3e4
Message-ID: <84144f020906150827k1b8c0ce4q5ed4d140f7ca869@mail.gmail.com>
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, npiggin@suse.de, yinghai@kernel.org,
       benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Mon, Jun 15, 2009 at 6:11 PM, Pekka Enberg<penberg@cs.helsinki.fi> wrote:
>> > But does this matter? When the debugging options are turned off, there
>> > are no users for "real_gfp" and thus GCC optimizes everything away. For
>> > debugging configs, the extra cacheline load doesn't matter, does it?
>>
>> It cleaner to have the fastpath as small as possible. Having unused
>> variables in there is a bit confusing.
>
> OK, I can clean this up, no problem.

Actually, there's a slight complication here. If I push gfp mask to
__might_sleep(), lockdep_trace_alloc() and so on, the mask is
effective _everywhere_ even outside of slab. Yes, it makes sense if we
push the masking right down to the page allocator but I wonder if
that's something we want to do at this point?

                                Pekka
