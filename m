Return-Path: <linux-kernel-owner+w=401wt.eu-S1757130AbYKWH5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130AbYKWH5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 02:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbYKWH5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 02:57:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYKWH5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 02:57:38 -0500
Message-ID: <49290CEB.7070509@suse.de>
Date: Sun, 23 Nov 2008 16:57:31 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com, Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Subject: Re: about TRIM/DISCARD support and barriers
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
In-Reply-To: <4929023C.2060302@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Dongjun, the only doc I can find about ATA TRIM is the following one.
> 
>  http://t13.org/Documents/UploadedDocuments/docs2007/e07154r3-Data_Set_Management_Proposal_for_ATA-ACS2.pdf
> 
> And AFAICS this hasn't made into ACS yet.  Is this what you guys are
> gonna implement and Windows7 is gonna use?

Just went over it.  Matthew, if ATA trim is gonna be implemented as
described in the above document, it will support multiple ranges per
command.

Dongjun, the above document strikes out all the latency/performance
related stuff, which looks like the right move to me.  Most of those
information can be extracted from access pattern by the device itself
and exposing such optimization parameters to outside seldom works well.
 I'm fairly sure such over complexity will end up being
counter-optimization due to different interpretations and executions by
different parties (be it harddrive vendors or different filesystems).

So, can you please confirm that, what we eventually get is simple TRIM
w/ multiple ranges?  Which, BTW, makes sense as it's something the
device can't infer from the access pattern.  Also, if there still is
wiggle room, what would be a worthy optimization is to allow TRIM
commands to be sent together with other NCQ commands as otherwise the
drive will have to drain all other commands to process a TRIM command
which will be inefficient.

Thanks.

-- 
tejun
