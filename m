Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbYI2JL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbYI2JL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbYI2JLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:11:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:48505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYI2JLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vqiOrGcNA6kFDkIo4+Mesz+zDzeXDHDOJq1mO3qq+B7QttKD59dA8eEhBV/u3D3wjW
         vo80iFAX/up3Q1HGJ67sXdgr9/sh5CJnjF7YNaf/ik+fD7k0kda+8FfrOgxzyt08w1Zz
         8PI8nOYvTuhAQh05nGyyqZuTNKJy3qGiXrB+I=
Message-ID: <c62985530809290211l7df01459lf80456ab98fc6ed0@mail.gmail.com>
Date: Mon, 29 Sep 2008 11:11:15 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Path -tip 1/3] Tracing/ftrace: Change the type of the print_line callback
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080928191918.1b26c0ab@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DCFEE1.4010102@gmail.com>
	 <20080928191918.1b26c0ab@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/28 Pekka Paalanen <pq@iki.fi>:
> I might have chosen names like TRACE_PRINT_{RETRY,DONE,DEFAULT_FORMAT},
> but it's your call. I'm not sure which one is more self-explanatory
> when you see a "return TRACE_...;" or "if (ret == TRACE_...)"

Hmm yes that's perhaps more explicit.


> Shouldn't the return type be bool?
> If it's not, reading this function makes me wonder about the conversion
> from enum to int, i.e. what is the meaning of the int.

Actually it should be enum print_line_t. I forgot to change its type.
But we need to check its return value as an enum print_line_t.

> It would be shorter to write
> if (ret != TRACE_TYPE_UNHANDLED)
> and then one could even
> return (ret == TRACE_TYPE_HANDLED);

Yes, I corrected it in my "week-end patch" :-)

> Do these actually need checking? I don't think
> the default print functions would ever return
> TRACE_TYPE_UNHANDLED, could they?
> And even if they did, do all the different default print
> functions not handle the same set of entry types?

At this moment they don't. But I just wanted to set a security in case
of possible future changes in these functions.


> We have to find a proper way to prevent the pipe from closing
> early. I'm trying to look into this. I'd like you to leave
> that last hunk out. Other than that, very good.

I made a new patch this week-end and I found a way to prevent from
closing the pipe.
I will just change a bit my patch in the base of your comments.

> btw. there might be a corner case, when a single line does not
> fit even into an empty struct trace_seq in tracing_read_pipe(),
> but I haven't thought of that yet. I'd expect it to hang.

I should look at this possible issue too. I didn't think about it yet.
