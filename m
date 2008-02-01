Return-Path: <linux-kernel-owner+w=401wt.eu-S1764022AbYBAMCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764022AbYBAMCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 07:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYBAMCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 07:02:15 -0500
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:48824 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbYBAMCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 07:02:15 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 07:02:14 EST
Date: Fri, 1 Feb 2008 12:55:30 +0100
From: Lars Noschinski <lkml@ml.noschinski.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does ext2 implement sparse files?
Message-ID: <20080201115530.GB14567@lars.home.noschinski.de>
References: <20080131152823.GA29422@lars.home.noschinski.de> <p73myql50d2.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <p73myql50d2.fsf@bingen.suse.de>
User-Agent: mutt-ng/devel-r804 (Linux)
X-Df-Sender: 336680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for using an invalid mail address in my previous post]

* Andi Kleen <andi@firstfloor.org> [08-02-01 10:28]:
>Lars Noschinski <lklml@ml.noschinski.de> writes:
>
>> For an university project, we had to write a toy filesystem (ext2-like),
>> for which I would like to implement sparse file support. For this, I
>> digged through the ext2 source code; but I could not find the point,
>> where ext2 detects holes.
>>
>> As far as I can see from fs/buffer.c, an hole is a buffer_head which is
>> not mapped, but uptodate. But I cannot find a relevant source line,
>> where ext2 makes usage of this information.
>
>It does not explicitely detect holes; holey data is just never written
>so no space for it is allocated.

Thanks for the answers. No that I know that, it is kind of obvious. I
was irritated yesterday by a bug a bug in our implementation (number of
used blocks is reported as filesize/blocksize); so I was expecting the
VFS to issue write requests for empty pages (which would be sillly, I
know).

Thanks,
     Lars.
