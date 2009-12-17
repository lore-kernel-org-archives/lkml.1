Return-Path: <linux-kernel-owner+w=401wt.eu-S965298AbZLQSuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298AbZLQSuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965266AbZLQSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:50:07 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:13449 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964935AbZLQSuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:50:02 -0500
X-Trace: 309356834/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0AAKoMKktPRRyw/2dsb2JhbAAI1nqELQQ
X-IronPort-AV: E=Sophos;i="4.47,414,1257120000"; 
   d="scan'208";a="309356834"
Date: Thu, 17 Dec 2009 18:49:35 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Rafael Almeida <almeidaraf@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: On the workings of mmap
In-Reply-To: <6de6b1650912171006j2ac942ay1f31286a05248433@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0912171842510.30830@sister.anvils>
References: <6de6b1650912171006j2ac942ay1f31286a05248433@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Rafael Almeida wrote:

> Hello. I have been studying the mmap function and it seems like when I
> map an sparse file, that the parts of the file that have nothing are
> defined as 0 when I access them through the address space returned by
> mmap. Is that luck or is it defined to be this way? My only source of
> information was debian's manpage on mmap that didn't seem to talk
> about sparse files at all.

That's not luck, it is required to be that way.

Though I've not located such a definition with respect to mmap(),
it would be perverse if mmap() showed you different data there from
what read() shows you, and the Single Unix Specification (Version 3)
says of read():

"If any portion of a regular file prior to the end-of-file has not
 been written, read() shall return bytes with value 0."

Hugh
