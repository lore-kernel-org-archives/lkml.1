Return-Path: <linux-kernel-owner+w=401wt.eu-S1761295AbYEHHmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761295AbYEHHmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 03:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbYEHHmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 03:42:07 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:12851 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYEHHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 03:42:05 -0400
Message-ID: <4822AECB.4040401@de.ibm.com>
Date: Thu, 08 May 2008 09:42:03 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/6] seq_file: add function to write binary data
References: <481F26B5.7010708@de.ibm.com>	<20080505213644.b153ee68.akpm@linux-foundation.org>	<20080507201757.GC5131@martell.zuzino.mipt.ru> <20080507204533.GA8850@martell.zuzino.mipt.ru>
In-Reply-To: <20080507204533.GA8850@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Thu, May 08, 2008 at 12:17:57AM +0400, Alexey Dobriyan wrote:
>> > > +		memcpy(m->buf + m->count, s, len);
>> > > +		m->count += len;
>> > > +		return 0;
>> > > +	}
>> > > +	m->count = m->size;
>> > > +	return -1;
>> > > +}
>> > > +EXPORT_SYMBOL(seq_write);
>> 
>> I'd call function seq_memcpy() though.
> 
> Or even seq_blob().

Hm, in my opinion seq_write() would fit more into the already existing
naming scheme of seq_file interface functions. The beauty of the idea
behind seq_file is that a user can just pretend to write to the buffer
that is read by a userspace application without having to worry about
full buffers, partial reads or seeks. In this context, the read becomes
a write and function names such as seq_printf(), seq_putc(), seq_puts()
or the suggested seq_write() seem to best fit this idea.


Regards,
  Peter
