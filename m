Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbYKXFkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbYKXFkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 00:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbYKXFkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 00:40:31 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:10447 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbYKXFka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 00:40:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LwVGPbhtp9ErVAmY/XkG2wzBpHzPkOUC0cUwuhf77z/R9KCd/DGh9Mi2VJyEyPVZbN
         fiLeDF9uQ4v5yXhijSPiuDWY2TJrIYZL4+ULO6Z5x/fGwov8u/USta9/Cm+36QNt2/8G
         eOXzyx0V7zGJVxtp9B5pUXf0wfEcjz50fA83I=
Message-ID: <7fe698080811232140ie896cc8m735a25261f447c47@mail.gmail.com>
Date: Mon, 24 Nov 2008 14:40:29 +0900
From: "Dongjun Shin" <djshin90@gmail.com>
To: "Tejun Heo" <teheo@suse.de>
Subject: Re: about TRIM/DISCARD support and barriers
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       dwmw2@infradead.org, "Nick Piggin" <npiggin@suse.de>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, chris.mason@oracle.com,
       "Matthew Wilcox" <matthew@wil.cx>
In-Reply-To: <49290CEB.7070509@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de>
	 <49290CEB.7070509@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 4:57 PM, Tejun Heo <teheo@suse.de> wrote:
> Tejun Heo wrote:
>> Dongjun, the only doc I can find about ATA TRIM is the following one.
>>
>>  http://t13.org/Documents/UploadedDocuments/docs2007/e07154r3-Data_Set_Management_Proposal_for_ATA-ACS2.pdf
>>
>> And AFAICS this hasn't made into ACS yet.  Is this what you guys are
>> gonna implement and Windows7 is gonna use?
>

Sorry, I thought the trim spec has got into the final ACS, but it's not yet.
Microsoft can collaborate with SSD vendors for their internal evaluation &
feedback for Win7(with NDA between them, of course).

> Just went over it.  Matthew, if ATA trim is gonna be implemented as
> described in the above document, it will support multiple ranges per
> command.
>
> Dongjun, the above document strikes out all the latency/performance
> related stuff, which looks like the right move to me.  Most of those
> information can be extracted from access pattern by the device itself
> and exposing such optimization parameters to outside seldom works well.
>  I'm fairly sure such over complexity will end up being
> counter-optimization due to different interpretations and executions by
> different parties (be it harddrive vendors or different filesystems).
>
> So, can you please confirm that, what we eventually get is simple TRIM
> w/ multiple ranges?  Which, BTW, makes sense as it's something the
> device can't infer from the access pattern.  Also, if there still is
> wiggle room, what would be a worthy optimization is to allow TRIM
> commands to be sent together with other NCQ commands as otherwise the
> drive will have to drain all other commands to process a TRIM command
> which will be inefficient.
>

AFAIK, only the trim feature of data set management command will be included
and a single trim may contain multiple ranges. But, it's not possible to send
non-read/write command during NCQ as specified by the t13(1).

-- 
Dongjun

(1) In 4.15 of ATA8-ACS,
"If the device receives a command that is not an NCQ command while NCQ commands
are in the queue, then the device shall return command aborted for the
new command
and for all of the NCQ commands that are in thequeue."
