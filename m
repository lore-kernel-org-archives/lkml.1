Return-Path: <linux-kernel-owner+w=401wt.eu-S965040AbYBAAY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965040AbYBAAY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 19:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755577AbYBAAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 19:24:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYBAAYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 19:24:15 -0500
Message-ID: <47A26680.6060500@zytor.com>
Date: Thu, 31 Jan 2008 16:23:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86: add a crc32 checksum to the kernel image.
References: <1201815920-24669-1-git-send-email-ijc@hellion.org.uk> <1201815920-24669-2-git-send-email-ijc@hellion.org.uk> <1201815920-24669-3-git-send-email-ijc@hellion.org.uk> <47A24765.3070300@zytor.com>
In-Reply-To: <47A24765.3070300@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> Hm.  I have some minor concerns about this:
> 
> * The classical length field is only available in multiples of 16 (I 
> realize your patches change that to some degree, but I'd hate to make 
> the guarantee that the image payload is the last thing in the image -- 
> it loses flexibility for the future.)  The end of the image isn't 
> available in all cases, so this would require padding it out to a 
> 16-byte boundary before appending the CRC32.  An mmap is guaranteed to 
> be zero-padded out to the next page boundary, so explicitly rounding sz 
> up (instead of when calculating sys_size) should do the job.
> 

Thinking about this more carefully, we should probably have it rounded 
up to a 16-byte boundary *including* the CRC32, so the CRC32 is included 
in the notional image.

	-hpa
