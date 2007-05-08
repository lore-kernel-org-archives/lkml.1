Return-Path: <linux-kernel-owner+w=401wt.eu-S968175AbXEHO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968175AbXEHO1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968169AbXEHO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:27:21 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:34653 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968133AbXEHO1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:27:20 -0400
Message-ID: <46408662.5070003@gmail.com>
Date: Tue, 08 May 2007 16:17:06 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
References: <464045F0.3040906@gmail.com> <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
In-Reply-To: <84144f020705080653i16d324c8pbd2925d844f400fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2007 03:53 PM, Pekka Enberg wrote:

>> +static int __mitsumi_read_toc(struct mitsumi_cdrom *mcd)
>> +{
>> +       int tracks = mcd->header.cdth_trk1 - mcd->header.cdth_trk0 + 1;
>> +       int retries;
>> +       int err = 0;
>> +
>> +       kfree(mcd->toc);
>> +
>> +       mcd->toc = kzalloc(tracks * sizeof *mcd->toc, GFP_KERNEL);
> 
> Perhaps we should use krealloc() + memset() here?

Earlier I had a patch lined up that checked the previous number of tracks 
against the current number and only freed the TOC array when they were not 
the same. The majority case is a data CD with one TOC entry meaning we just 
reuse the entry. You then have to keep the previous number of tracks though 
and it seemed a little pointless so I dropped it.

Another option is using a linked list for the TOC and reusing or allocating 
nodes upon reading the actual entry from the Q channel and freeing the rest 
when we got them all. Also seemed overly complex and the CDROMREADTOCENTRY 
gets slower ;-)

I admit my DOS inspired dislike of realloc() is largely pointless these days 
but, err... "E426: tag not found: krealloc". Would you perhaps like the 
list? Or the if (tracks != mcd->tracks) thing?

Rene.

