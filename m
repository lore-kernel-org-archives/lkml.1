Return-Path: <linux-kernel-owner+w=401wt.eu-S1758144AbZDFVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144AbZDFVgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756413AbZDFVgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:36:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:23226 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbZDFVgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:36:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=iqOvOjxq/sn8iQHZnkXmpg78CSJHzK3TbkiDVBq7lu+KsOSi1kh2pKUVd7CjESSCQt
         eEkXanikccHo29oDI9NPcz5Czut99e+HlnJ+m6pL/TpVXmlND+5To/hAQh8xdDtgj395
         irPl/N7k8a4G9IMBMoxXxqe1/uqUM9CplBjyo=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Theodore Tso'" <tytso@mit.edu>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Jens Axboe'" <jens.axboe@oracle.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk> <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain> <20090406183157.GD7376@mit.edu> <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain> <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
In-Reply-To: <20090406211931.GB8586@mit.edu>
Subject: RE: [PATCH 0/8][RFC] IO latency/throughput fixes
Date: Mon, 6 Apr 2009 14:35:51 -0700
Message-ID: <003001c9b6ff$a9259ce0$fb70d6a0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acm2/WQmSOux4INoTqaIz/dD3oH8DwAAFvSg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've added workarounds for 2.6.30 that provide the replace-via-rename
> and replace-via-truncate workarounds for ext3 data=writeback cases.
> See commits e7c8f507 and f7ab34ea.
> 
> There won't be an implied fsync for newly created files, yes, but you
> could have crashed 5 seconds earlier, at which point you would have
> lost the newly created file anyway.  Replace-via-rename and
> replace-via-truncate solves the problem for applications which are
> editing pre-existing files, which was most of people's complaints
> about depending on data=ordered semantics.

I am not talking about "most" people's complaints. There are use cases for
ext3 far beyond the desktop.

I worked on a user-space library on top of ext3 before on embedded systems.
It may not have been the case for me but I could well imagine where it could
get too clever and depend upon "ordered". You really don't want to silently
corrupt people's data by changing the default. How about security too?
Wasn't that the original reason for "ordered" mode?

Ext3 is supposed to be a stable filesystem, while ext4 is the shiny new
filesystem that gets to do all the exciting experiments. I thought it was
the idea. People do not expect such a change at this stage, for better or
worse. It's great that you can improve its performance, but the performance
problem wasn't introduced yesterday, so if people care they could always
mount it as writeback, but there is no urgency in doing it for them. A
default semantic change is just crazy talk.

Hua


