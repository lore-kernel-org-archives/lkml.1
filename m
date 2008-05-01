Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbYEAQ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbYEAQ3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbYEAQ3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:29:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56183 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbYEAQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:29:41 -0400
Message-ID: <4819EFEE.4040601@us.ibm.com>
Date: Thu, 01 May 2008 11:29:34 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Carl Love <cel@us.ibm.com>
CC: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH] Updated: Reworked Cell OProfile: SPU mutex lock fix
References: <1209652994.17842.1.camel@carll-linux-desktop>
In-Reply-To: <1209652994.17842.1.camel@carll-linux-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carl Love wrote:
> Sorry, looks like my mailer mangled the file.
>
> This is a reworked patch to fix the SPU data storage.  Currently, the 
> SPU escape sequences and program counter data is being added directly 
> into the kernel buffer without holding the buffer_mutex lock.  This 
> patch changes how the data is stored.  A new function,
> oprofile_add_value, is added into the oprofile driver to allow adding
> generic data to the per cpu buffers.  This enables a series of calls
> to the oprofile_add_value to enter the needed SPU escape sequences 
> and SPU program data into the kernel buffer via the per cpu buffers
> without any additional processing. The oprofile_add_value function is
> generic so it could be used by other architecures as well provided
> the needed postprocessing was added to opreport.
>
> Finally, this patch backs out the changes previously added to the 
> oprofile generic code for handling the architecture specific 
> ops.sync_start and ops.sync_stop that allowed the architecture
> to skip the per CPU buffer creation.
>
> Signed-off-by: Carl Love <carll@us.ibm.com>
>   
Looks fine to me.  All of my previous review comments have been addressed.

-Maynard
[snip]

