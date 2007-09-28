Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbXI1XtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbXI1XtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 19:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbXI1XtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 19:49:14 -0400
Received: from mailout02.sul.t-online.de ([194.25.134.17]:36523 "EHLO
	mailout02.sul.t-online.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbXI1XtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 19:49:13 -0400
Message-ID: <46FD92CF.70708@t-online.de>
Date: Sat, 29 Sep 2007 01:48:31 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070810)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: bryan.wu@analog.com, davidm@snapgear.com, gerg@snapgear.com,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] binfmt_flat: minimum support for the Blackfin relocations
References: <1190102965.4406.9.camel@roc-desktop> <20070928160826.1483b9ba.akpm@linux-foundation.org>
In-Reply-To: <20070928160826.1483b9ba.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: SUDMEOZGZhYuq0jl7aGKQB3CSMzKEmnggBcOweEEkJ9zUYCtK4fJgMI7UA7CJXxQjp
X-TOI-MSGID: 22b83251-f79f-4618-9c15-e160ff9ba5ed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>>  	if (rev > OLD_FLAT_VERSION) {
>> +		unsigned long persistent = 0;
> 
> `persistent' here only has meaning inside the next nesting level, so should
> be moved down into that scope for readability reasons.

See below.

>> +			if (flat_set_persistent (relval, &persistent))
>> +				continue;
> 
> If this correct?  flat_set_persistent() returns zero if it didn't write
> anything to `persistent'.  It seems strange that in the case where
> flat_set_persistent() _does_ write something to `persistent', we just throw
> it away by doing `continue'.
> 
> Either that, or I've misread the code and you really did mean to put
> `persistent' in the outer scope, and its value is supposed to propagate
> over into the next iteration of the loop.  If so, that's all a bit too
> tricky for it to be implemented with zero code comments, dontcha think?

The latter.  We need to be able to use more data than we can fit into a 
single reloc, so we store a value with one reloc and reuse it with the 
next.  There'd be no point in having this function otherwise since you 
could perform whatever needs to be done in flat_get_relocate_addr.

This seemed fairly obvious at the time... when you're familiar with the 
flat format, the loop isn't all that hard to understand.  I'll add 
comments in the next version.


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
