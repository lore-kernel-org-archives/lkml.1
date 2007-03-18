Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXCRWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXCRWBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933330AbXCRWBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:01:44 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1834 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbXCRWBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:01:43 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 19 Mar 2007 07:01:28 +0900
In-Reply-To: <45FD6EF5.1030706@ums.usu.ru> (Alexander E. Patrakov's message of "Sun\, 18 Mar 2007 21\:55\:17 +0500")
Message-ID: <87hcsius7b.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

>  * Removes CONFIG_FAT_DEFAULT_IOCHARSET, now CONFIG_NLS_DEFAULT is used 
> for this purpose. This is because the correct setting of both must match 
> the user's locale

The some filesystems want to use utf-8, and others don't want to use
utf-8, no?  And is it also true about some devices using vfat?

>  * Merges the two CONFIG_SMB_NLS_REMOTE and CONFIG_FAT_DEFAULT_CODEPAGE 
> options into one, named CONFIG_CODEPAGE_DEFAULT. This is because the 
> correct setting of both must match the code page used by MS-DOS in the 
> user's country. For the same reason, CONFIG_SMB_NLS_DEFAULT is removed 
> (the only sane choice is "y")

No. Unfortunately the real is not simple like it in some case.

>  * Makes the FAT filesystem accept both the old-style "codepage=866" 
> mount option (which is inconsistent with other filesystems requiring a 
> codepage option) and the new-style "codepage=cp866" option. This is 
> necessary because CONFIG_CODEPAGE_DEFAULT must work for all filesystems 
> that use it

You allow to set any nls to codepage? If so, it is not good.

>  * Downgrades the UTF-8 FAT warning to a note, because, while using the 
> utf8 iocharset produces a case-sensitive FAT filesystem, other 
> iocharsets simply produce wrong characters, which is much worse

No, utf-8 makes completely wrong entry. It's more wrong than other nls.

>  * Makes CONFIG_NLS_DEFAULT and CONFIG_CODEPAGE_DEFAULT adjustable at 
> runtime via the following mechanisms:

The configurable sounds sane, and it may help some case. But, it should
not be system global. At least, I think the default would be per-filesystem,
otherwise some configs seems to be needed for other filesystem after all.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
