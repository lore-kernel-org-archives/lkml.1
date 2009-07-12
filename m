Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZGLPA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZGLPA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 11:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZGLPAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 11:00:17 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:9054
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754066AbZGLPAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 11:00:16 -0400
Message-ID: <4A59FA7D.1040009@panasas.com>
Date: Sun, 12 Jul 2009 18:00:13 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Nick Piggin <npiggin@suse.de>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
References: <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org>
In-Reply-To: <20090712144717.GA18163@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jul 2009 15:00:15.0535 (UTC) FILETIME=[76BBCBF0:01CA0301]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2009 05:47 PM, Christoph Hellwig wrote:
> On Sun, Jul 12, 2009 at 11:55:51AM +0300, Boaz Harrosh wrote:
>> I wish you would split it.
>>
>> one - helper to be called by converted file systems
>>       (Which just ignores the ATTR_SIZE)
>> second - to be set into .setattr which does the simple_setsize + above.
>>
>> More clear for FS users like me (and that ugly unmask of ATTR_SIZE)
>>
>> or it's just me?
> 
> Yeah, that seems be a lot cleaner.  But let's wait until we got
> rid of ->truncate for all filesystems to have the bigger picture.
> 

I want to convert exofs. do you want that I call inode_setattr clearing
ATTR_SIZE bit, and at second stage remove the clearing and rename inode_setattr
to something else?

When it's time to convert exofs, tel me I'll do it. I have dependent work
on top of that, and I want to cleanup the delete_inode as well as some other
leftovers.

(BTW For none-buffer-heads systems like exofs the new way makes lots of sense)

Thanks
Boaz
