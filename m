Return-Path: <linux-kernel-owner+w=401wt.eu-S965620AbXCSFth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965620AbXCSFth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCSFth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:49:37 -0400
Received: from relay4.usu.ru ([194.226.235.39]:41100 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXCSFtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:49:36 -0400
Message-ID: <45FE2483.4060706@ums.usu.ru>
Date: Mon, 19 Mar 2007 10:49:55 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>
In-Reply-To: <87vegxdc8i.fsf@duaron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:

> I don't care about "read", because it doesn't corrupt filesystem. I care
> about only "write", because it can corrupt filesystem.
> 
> If it's read-only, I'll not care at all, and will agree.

Here you are right, but please tell RedHat about this (and you'll be at 
least called an old-fashioned person). They (and from their initiative, 
almost everyone else) use UTF-8 based locales by default, and ONLY utf8 NLS 
gives correct characters in filenames in this case.

Besides, FS corruption is possible only if the user intentionally writes two 
files with names differing only in their case.


> All are user policy. The users can switch locale and
> G_FILENAME_ENCODING and something else, some app can switch it even
> runtime, and I think kernel shouldn't have user policy, right?

G_FILENAME_ENCODING is a Glib2-only heresy, please ignore it. The "ls" tool 
always assumes that file names are in the same encoding as the output of 
"locale charmap" command. The fact that the filenames (contrary to what 
Glib2 developers say) should be in the locale encoding becomes very obvious 
if one reads POSIX specifications for tar and cpio programs (otherwise, they 
won't talk about conversion errors).

-- 
Alexander E. Patrakov
