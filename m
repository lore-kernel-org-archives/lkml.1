Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbXHZRlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbXHZRlw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 13:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbXHZRlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 13:41:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:31955 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbXHZRlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 13:41:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n6uaO9s5WEQwKugIHUBE/+2+zaJt63POs09V8qP/SsEjZpkyj7X9INpG6eUwrnqBFweOBA39WqxhnrwqQw2qAttzlr0A9u3l/K9S4hxuVujr0rMDlzuX1+q6gl7hnvPQtUoJYIKtuBmU273aDw2+vUEs6tF6Aa4FLUEeXLRiKeE=
Message-ID: <466ad3f90708261041g72fee1a2q2f541161884d4499@mail.gmail.com>
Date: Sun, 26 Aug 2007 13:41:44 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: vda.linux@googlemail.com, linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <200708261803.12717.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
	 <Pine.LNX.4.64.0708261752260.15614@fbirervta.pbzchgretzou.qr>
	 <466ad3f90708260916x5d19d0d3hd828e63520960192@mail.gmail.com>
	 <200708261803.12717.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> On Sunday 26 August 2007 17:16, Fred Tyler wrote:
> > So, I guess it worked? (I don't know what was supposed to happen, but
> > memory usage dropped significantly when I did this.)
>
> If you can reclaim "leaked" memory this way, it means that
> you found a bug where cached data is incorrectly kept
> in RAM in preference of other data.
> (I'm assuming that you do have real problems after some time
> of "leaking" memory - you mention that you get swap storms
> and eventually machine is dead.)

This was exactly what happened with 2.6.12 -- more and more memory
used until there was a swap storm and a dead machine.

The 2.6.20 machines haven't been up long enough to know if they're
going to be hit by the same problem, but it seems peculiar to me that
the 2.6.16 machine does not do anything remotely like this. As you can
see in the graphs, the 2.6.16 memory use levels off very quickly, but
2.6.12 keeps dropping until the machine bombs.

The 2.6.20 graph looks like it's heading the same direction as 2.6.12.

I'm going to run drop_caches on the 2.6.20 machines tonight and see
what happens...
