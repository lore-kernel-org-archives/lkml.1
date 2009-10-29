Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056AbZJ2IRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbZJ2IRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZJ2IRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:17:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbZJ2IRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:17:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Miller <davem@davemloft.net>
Subject: Re: is avoiding compat ioctls possible?
Date: Thu, 29 Oct 2009 09:16:50 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: arndbergmann@googlemail.com, airlied@linux.ie,
       dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
References: <200910281313.32827.arnd@arndb.de> <200910281640.18491.arnd@arndb.de> <20091028.224157.92041844.davem@davemloft.net>
In-Reply-To: <20091028.224157.92041844.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910290916.50367.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX192tTYlA4WbjO3PKGFyFXUTi/pRB0fBm8Zc0ZO
 x9tL1znqAMqxmnxxpg5gIBBG7tAJ6762SV9TdLxJLFbvnQzncf
 dYxQIcngf2Vk8t6NBhKwQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 October 2009, David Miller wrote:
> Arnd, even compat_sys_ioctl() itself has constructs like:
> 
>         case FS_IOC_RESVSP:
>         case FS_IOC_RESVSP64:
>                 error = ioctl_preallocate(filp, (void __user *)arg);
>                 goto out_fput;

Right. This one is pretty recent and I did not notice it doing this
unfortunately. There are a few others added to fs/compat_ioctl.c
over the years also doing it.

	Arnd <><
