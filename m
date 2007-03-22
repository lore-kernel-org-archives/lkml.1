Return-Path: <linux-kernel-owner+w=401wt.eu-S1750773AbXCVM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750773AbXCVM72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 08:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbXCVM72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 08:59:28 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:45578 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbXCVM71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 08:59:27 -0400
Date: Thu, 22 Mar 2007 13:59:04 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
In-Reply-To: <45FD6EF5.1030706@ums.usu.ru>
Message-ID: <Pine.LNX.4.64.0703221350400.14458@scrub.home>
References: <45FD6EF5.1030706@ums.usu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 18 Mar 2007, Alexander E. Patrakov wrote:

> More details on what the patch does:
> 
> * Rewords the description of CONFIG_NLS_DEFAULT, because at some point in the
> past it confused some people
> * Removes CONFIG_FAT_DEFAULT_IOCHARSET, now CONFIG_NLS_DEFAULT is used for
> this purpose. This is because the correct setting of both must match the
> user's locale
> * Merges the two CONFIG_SMB_NLS_REMOTE and CONFIG_FAT_DEFAULT_CODEPAGE options
> into one, named CONFIG_CODEPAGE_DEFAULT. This is because the correct setting
> of both must match the code page used by MS-DOS in the user's country. For the
> same reason, CONFIG_SMB_NLS_DEFAULT is removed (the only sane choice is "y")
> * Makes the FAT filesystem accept both the old-style "codepage=866" mount
> option (which is inconsistent with other filesystems requiring a codepage
> option) and the new-style "codepage=cp866" option. This is necessary because
> CONFIG_CODEPAGE_DEFAULT must work for all filesystems that use it
> * Downgrades the UTF-8 FAT warning to a note, because, while using the utf8
> iocharset produces a case-sensitive FAT filesystem, other iocharsets simply
> produce wrong characters, which is much worse
> * Renames SMB_NLS_MAXNAMELEN to NLS_MAXNAMELEN, because it is also useful
> outside smbfs
> * Makes smbfs always output iocharset and codepage in /proc/mounts, as FAT
> does
> * Makes CONFIG_NLS_DEFAULT and CONFIG_CODEPAGE_DEFAULT adjustable at runtime
> via the following mechanisms:

I agree that these parameters should be changable not just at compile time 
and the iocharset should be a global default, but the on disk encoding is 
often filesystem specific, so I'd rather keep this option per filesystem.

bye, Roman
