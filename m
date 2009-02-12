Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZBLDLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZBLDLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbZBLDLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:11:04 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:63397 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZBLDLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:11:03 -0500
Message-Id: <200902120310.n1C3AwHL076677@www262.sakura.ne.jp>
Subject: Description of open_to_namei_flags()?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 12 Feb 2009 12:10:58 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 12022009 #1608725, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> /*
>  * Note that while the flag value (low two bits) for sys_open means:
>  *      00 - read-only
>  *      01 - write-only
>  *      10 - read-write
>  *      11 - special
>  * it is changed into
>  *      00 - no permissions needed
>  *      01 - read-permission
>  *      10 - write-permission
>  *      11 - read-write
>  * for the internal routines (ie open_namei()/follow_link() etc)
>  * This is more logical, and also allows the 00 "no perm needed"
>  * to be used for symlinks (where the permissions are checked
>  * later).
>  *
>  */
> static inline int open_to_namei_flags(int flag)
> {
> 	if ((flag+1) & O_ACCMODE)
> 		flag++;
> 	return flag;
> }

I noticed that open_to_namei_flags() can't yield
"00 - no permissions needed" output for "11 - special" input.
To yield "00 - no permissions needed" output for "11 - special" input,
I think

  static inline int open_to_namei_flags(int flag)
  {
  	return (flag + 1) & O_ACCMODE;
  }

is needed.

sys_open(path, 0) is open for reading.
sys_open(path, 1) is open for writing.
sys_open(path, 2) is open for reading and writing.
What is sys_open(path, 3) for?

Regards.
