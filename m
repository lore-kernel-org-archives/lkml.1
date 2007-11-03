Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbXKCWNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbXKCWNP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 18:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756204AbXKCWNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 18:13:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:38118 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbXKCWM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 18:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XpkSp48/6Ve69gJIPg4p+4+IGZTd4JnklT4yLX6K6fkq5wMK20t2CdTXh/v9ahTe0JuJCoME6MyvtVLe+dhDXVzk7niP6nT8r3W2yjxGBRyg02yEjTwH3kA/MXRortswBfusQiODXa4FbW6FFFtGluxlUztST2BXWZ/NY2BL0aQ=
Message-ID: <1865922a0711031512g101da6a8ydb85520037a8b655@mail.gmail.com>
Date: Sun, 4 Nov 2007 00:12:58 +0200
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
To: "Kyle Moffett" <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Cc: "Casey Schaufler" <casey@schaufler-ca.com>, akpm@osdl.org,
       torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45A82524-172E-4F18-B660-981D5A1A6D75@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071103164303.GA26707@ubuntu>
	 <45A82524-172E-4F18-B660-981D5A1A6D75@mac.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/3/07, Kyle Moffett <mrmacman_g4@mac.com> wrote:
> On Nov 03, 2007, at 12:43:06, Ahmed S. Darwish wrote:
> > Bashv3 builtin "echo" behaves very strangely to -EINVAL. It sends
> > all the buffers that causes -EINVAL again in subsequent echo
> > invocations.
> >
> > i.e.
> > echo "Invalid Rule" > /smack/load  # -EINVAL returned
> > echo "Valid Rule" > /smack/load
> >
> > In seconod iteration, echo sends the first invalid buffer again
> > then sends the new one. This causes a "Invalid Rule\nValid Rule"
> > buffer sent to write().
> >
> > IMHO, this is a bug in builtin echo. The external /bin/echo doesn't
> > cause such strange behaviour.
>
> Actually, what causes problems here is something between a bug and a
> feature in libc's buffering.  Basically the -EINVAL error causes libc
> to leave its data in the file-output buffer despite the file being
> closed and reopened. Since a standalone echo just exits that buffer
> is discarded, but for the bash builtin it hangs around in the buffer
> for a while and ends up getting prepended to the following echo
> statement.  There's actually multiple ways to make this fail; this is
> just the simplest.
>

Thanks a lot for such a useful info. Is there a way from my side  to
make subsequent echo invocations not affected by previous failed ones
?

Regards,

-- 
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
