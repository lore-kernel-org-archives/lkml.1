Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbYKXFpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbYKXFpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbYKXFpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:45:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:41458 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbYKXFpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:45:35 -0500
Message-ID: <492A3F77.30009@suse.de>
Date: Mon, 24 Nov 2008 14:45:27 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Dongjun Shin <djshin90@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, chris.mason@oracle.com,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: about TRIM/DISCARD support and barriers
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>	 <49290CEB.7070509@suse.de> <7fe698080811232140ie896cc8m735a25261f447c47@mail.gmail.com>
In-Reply-To: <7fe698080811232140ie896cc8m735a25261f447c47@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongjun Shin wrote:
>> So, can you please confirm that, what we eventually get is simple TRIM
>> w/ multiple ranges?  Which, BTW, makes sense as it's something the
>> device can't infer from the access pattern.  Also, if there still is
>> wiggle room, what would be a worthy optimization is to allow TRIM
>> commands to be sent together with other NCQ commands as otherwise the
>> drive will have to drain all other commands to process a TRIM command
>> which will be inefficient.
>>
> 
> AFAIK, only the trim feature of data set management command will be included
> and a single trim may contain multiple ranges. But, it's not possible to send
> non-read/write command during NCQ as specified by the t13(1).

Yeah, I know the scheduling restriction and that's exactly why I was
asking.  To rephrase: I think it would be nice to make TRIM an NCQ
command as it's likely to get mixed with regular IO traffic a lot but
maybe we can schedule it strategically such that it follows FLUSH or the
queue is mostly idle.  Anyways, if someone knows anyone working on this,
please feel free to poke.

Thanks.

-- 
tejun
