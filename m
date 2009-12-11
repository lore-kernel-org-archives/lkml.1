Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZLKMUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZLKMUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZLKMUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:20:20 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42394 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZLKMUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:20:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=um0NzgXh6spXPao06RFTZJ1pvjiEzTIRgEQ2mUiaMe0Y9QBw7QTYSvjS+OlIYHLLXn
         CNpz176zF6jaf/+6Dbzn5A73tPQB0kZwxAZVhoQhwj6HeqjIauLtC90nqqooSdthHwHB
         yHrNAs57T+BvZA5eGiT8Oh7ApgwYEXYefPb6U=
MIME-Version: 1.0
In-Reply-To: <4B2217D0.5000308@cn.fujitsu.com>
References: <4B2217D0.5000308@cn.fujitsu.com>
From: Frederic Riss <frederic.riss@gmail.com>
Date: Fri, 11 Dec 2009 13:20:04 +0100
Message-ID: <87d3b2040912110420w270cff7ew36a7f2389a88fdb9@mail.gmail.com>
Subject: Re: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/11 Li Zefan <lizf@cn.fujitsu.com>:
> For '*foo' pattern, we should allow any string ending with
> 'foo', but ftrace filter incorrectly disallows strings
> like bar_foo_foo:
[...]
>        case MATCH_END_ONLY:
> -               ptr = strstr(str, regex);
> -               if (ptr && (ptr[len] == 0))
> +               slen = strlen(str);
> +               if (slen >= len && memcpy(str + slen - len, regex, len))
>                        matched = 1;

Shouldn't that be memcmp() == 0? I don't see how memcpy might serve as
a compare operator.

Fred.
