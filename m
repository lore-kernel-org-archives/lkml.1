Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXCVQHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXCVQHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 12:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933761AbXCVQHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 12:07:32 -0400
Received: from relay4.usu.ru ([194.226.235.39]:34810 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663AbXCVQHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 12:07:32 -0400
Message-ID: <4602A9D9.2060008@ums.usu.ru>
Date: Thu, 22 Mar 2007 21:07:53 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, agalakhov@ifmlrs.uran.ru,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru>
In-Reply-To: <45FD6EF5.1030706@ums.usu.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:

> More details on what the patch does:
> 
> * Rewords the description of CONFIG_NLS_DEFAULT, because at some point 
> in the past it confused some people
> * Removes CONFIG_FAT_DEFAULT_IOCHARSET, now CONFIG_NLS_DEFAULT is used 
> for this purpose. This is because the correct setting of both must match 
> the user's locale
> * Merges the two CONFIG_SMB_NLS_REMOTE and CONFIG_FAT_DEFAULT_CODEPAGE 
> options into one, named CONFIG_CODEPAGE_DEFAULT. This is because the 
> correct setting of both must match the code page used by MS-DOS in the 
> user's country. For the same reason, CONFIG_SMB_NLS_DEFAULT is removed 
> (the only sane choice is "y")
> * Makes the FAT filesystem accept both the old-style "codepage=866" 
> mount option (which is inconsistent with other filesystems requiring a 
> codepage option) and the new-style "codepage=cp866" option. This is 
> necessary because CONFIG_CODEPAGE_DEFAULT must work for all filesystems 
> that use it
> * Downgrades the UTF-8 FAT warning to a note, because, while using the 
> utf8 iocharset produces a case-sensitive FAT filesystem, other 
> iocharsets simply produce wrong characters, which is much worse
> * Renames SMB_NLS_MAXNAMELEN to NLS_MAXNAMELEN, because it is also 
> useful outside smbfs
> * Makes smbfs always output iocharset and codepage in /proc/mounts, as 
> FAT does
> * Makes CONFIG_NLS_DEFAULT and CONFIG_CODEPAGE_DEFAULT adjustable at 
> runtime via the following mechanisms:

I take the patch back, please expect V2. It needs some work WRT hfs and 
ncpfs filesystems, as well as an improvement in handling of iocharset=utf8 
in the fat filesystem.

-- 
Alexander E. Patrakov
