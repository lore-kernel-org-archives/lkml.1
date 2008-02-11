Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYBKQGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYBKQGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 11:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755282AbYBKQGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 11:06:11 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38415 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbYBKQGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 11:06:09 -0500
Message-ID: <47B0725C.30407@panasas.com>
Date: Mon, 11 Feb 2008 18:05:48 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org>
In-Reply-To: <20080211102339.GD11671@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw this too with checkpatch.pl version 0.12
It seems like checkpatch.pl knows only about types derived
from @typeList by build_types.

Example below...

Benny

$ cat <<EOF | scripts/checkpatch.pl -
Signed-off-by: john@smith.net
---
diff a/f.c b/f.c
--- a/f.c
+++ b/f.c
@@ -1,0 +1,2 @@
+foo(int a, my_uint32 *);
+bar(int a, my_uint32_t *);
EOF
ERROR: need consistent spacing around '*' (ctx:WxB)
#7: FILE: f.c:1:
+foo(int a, my_uint32 *);
                      ^

total: 1 errors, 0 warnings, 2 lines checked

On Feb. 11, 2008, 12:23 +0200, Andy Whitcroft <apw@shadowen.org> wrote:
> On Sun, Feb 10, 2008 at 03:33:02PM +0100, Marcin Slusarz wrote:
>> Hi
>>
>> Checkpatch in current mainline outputs following errors:
>>
>> $ ./scripts/checkpatch.pl -q --file ./fs/udf/misc.c
>> ERROR: need consistent spacing around '*' (ctx:WxV)
>> #205: FILE: fs/udf/misc.c:205:
>> +       tag *tag_p;
>>             ^
>>
>> $ ./scripts/checkpatch.pl -q --file ./fs/udf/unicode.c
>> ERROR: need consistent spacing around '*' (ctx:WxV)
>> #48: FILE: fs/udf/unicode.c:48:
>> +int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
>>                                                ^
>> (...)
>>
>> I think the code is ok.
> 
> Yep the code is clearly correct.  Can I have the whole patch fragment
> you got these against so I can figure out why we are unable to detect
> these two as types, I would expect us to have done so.  Also what
> version of checkpatch is this?  There is a version string at the top.
> 
> -apw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

