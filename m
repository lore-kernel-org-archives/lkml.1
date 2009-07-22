Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbZGVP2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbZGVP2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZGVP2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:28:14 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62886 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZGVP2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i9FYi9nBjucjezvWvCHLTbo/FTesoNstHZ/trRjY4ByN3ZbBbt4DB3CTuX0R02nlMB
         5U+dkkebThwB4QxCza8qlixKart2SufpGDem5PUXA86YYluKHcbvtrD/ihlNizchYqge
         w2Q5PnEpeu0Mo8VDZ14+WJs/DVnuokGFTgRhU=
MIME-Version: 1.0
In-Reply-To: <1248272032.4534.27.camel@tlielax.poochiereds.net>
References: <1248262099-12514-1-git-send-email-jlayton@redhat.com>
	 <1248262099-12514-2-git-send-email-jlayton@redhat.com>
	 <20090722125945.GA2834@cmpxchg.org>
	 <1248269879.4534.12.camel@tlielax.poochiereds.net>
	 <20090722135110.GA3091@cmpxchg.org>
	 <1248272032.4534.27.camel@tlielax.poochiereds.net>
Date: Wed, 22 Jul 2009 10:28:12 -0500
Message-ID: <524f69650907220828r25321e4ej6364213a97f7b63b@mail.gmail.com>
Subject: Re: [PATCH] fix offset checks in do_sendfile to use unsigned values
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 9:13 AM, Jeff Layton<jlayton@redhat.com> wrote:
> On Wed, 2009-07-22 at 15:51 +0200, Johannes Weiner wrote:
>
>> > Any of these patches will fix the immediate problem, but I think this
>> > code in do_sendfile should still account for the possibility that
>> > someone can set the value larger than MAX_LFS_FILESIZE. An alternative
>> > is to consider a WARN at mount time when filesystems set s_maxbytes
>> > larger than that value (that might help catch out of tree filesystems
>> > that get this wrong and prevent this sort of silent bug in the future).
>>
>> Isn't MAX_LFS_FILESIZE by definition the maximum sensible value for
>> s_maxbytes?
>>
>
> Pretty much, but nothing seems to enforce it or let you know when you've
> exceeded it. It sort of seems like s_maxbytes ought to be loff_t or
> something instead of an unsigned long long. A negative value there
> wouldn't make much sense, but no one would be as tempted to set it
> higher than MAX_LFS_FILESIZE.
>
>> > Either way, the patch I posted for this isn't sufficient since there are
>> > some checks that need to be done against the signed values (the
>> > (pos < 0) check, for instance). I'll post a respun patch in a bit that
>> > should fix up those problems.
>>
>> That is already handled in rw_verify_area(), I think, so we should be
>> able to drop it completely.
>
> If we get rid of those checks altogether, then "max" will become unused.
> Is that really OK here?
>
> For discussion purposes, I've attached a replacement patch that I'm
> working with now.

Looks fine to me


-- 
Thanks,

Steve
