Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbXFAEOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbXFAEOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 00:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXFAEOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 00:14:16 -0400
Received: from terminus.zytor.com ([192.83.249.54]:57993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXFAEOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 00:14:15 -0400
Message-ID: <465F9BEF.20504@zytor.com>
Date: Thu, 31 May 2007 21:09:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>, linux-kernel@vger.kernel.org,
       cotte@de.ibm.com, hugh@veritas.com, neilb@suse.de, zanussi@us.ibm.com,
       Linus Torvalds <torvalds@osdl.org>, hch@infradead.org
Subject: Re: [PATCH] sendfile removal
References: <20070531103316.GO32105@kernel.dk> <20070531124753.a99f713c.dada1@cosmosbay.com> <20070531105321.GQ32105@kernel.dk>
In-Reply-To: <20070531105321.GQ32105@kernel.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>>   
>>> -	retval = in_file->f_op->sendfile(in_file, ppos, count, file_send_actor, out_file);
>>> +	fl = 0;
>>> +	if (in_file->f_flags & O_NONBLOCK)
>>> +		fl = SPLICE_F_NONBLOCK;
>>> +
>>> +	retval = do_splice_direct(in_file, ppos, out_file, count, fl);
>> I like this, but are you sure it wont break user land ?
>>
>> Some applications might react badly if sendfile() returns EAGAIN ?
> 
> Yeah, I didn't actually intend for that to sneak in. I'd think that
> userspace should handle it if they opened the file O_NONBLOCK (or used
> fcntl()), but it's a change in behaviour none the less and probably not
> a good idea.
> 

I would personally argue that sendfile() blocking on an O_NONBLOCK
desriptor, as opposed to returning EAGAIN, is a bug, and a fairly
serious such.

	-hpa
