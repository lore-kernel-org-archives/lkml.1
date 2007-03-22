Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXCVNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXCVNVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXCVNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:21:55 -0400
Received: from relay4.usu.ru ([194.226.235.39]:57085 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbXCVNVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:21:54 -0400
Message-ID: <46028303.7070104@ums.usu.ru>
Date: Thu, 22 Mar 2007 18:22:11 +0500
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <Pine.LNX.4.64.0703221350400.14458@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0703221350400.14458@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:

> I agree that these parameters should be changable not just at compile time 
> and the iocharset should be a global default, but the on disk encoding is 
> often filesystem specific, so I'd rather keep this option per filesystem.

You are right, the on-disk encoding is filesystem specific. E.g., it is 
always UCS-2 for CIFS, NTFS and VFAT (and my patch doesn't change this).

It is exposed as a mount parameter and kernel configuration option only for 
fat and smbfs (the two filesystems that my patch touches for this matter), 
and both of these filesystems come from DOS days, where there was one 
codepage for a given country. So, for me, it made sense to glue these two 
parameters, because they both should be set to this codepage. The contrary 
would (AFAIK) only make sense if one gets floppies from France, but 
communicates with Polish SMB servers. It is a very rare situation, isn't it? 
Or do you know any other example where it would clearly make sense to have 
different defaults for fat and smbfs?

-- 
Alexander E. Patrakov
