Return-Path: <linux-kernel-owner+w=401wt.eu-S933315AbXBESd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315AbXBESd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933231AbXBESdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:33:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4026 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933012AbXBESYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:24:44 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 10:24:34 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <EDD3B5A9-9EAB-4E0A-BE1F-3B73C3870DC8@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051022170.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
 <EDD3B5A9-9EAB-4E0A-BE1F-3B73C3870DC8@oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Zach Brown wrote:

> > Since I still think that the many-thousands potential async operations
> > coming from network sockets are better handled with a classical event
> > machanism [1], and since smooth integration of new async syscall into the
> > standard POSIX infrastructure is IMO a huge win, I think we need to have a
> > "bridge" to allow async completions being detectable through a pollable
> > (by the mean of select/poll/epoll whatever) device.
> 
> Ugh, I'd rather not if we don't have to.
> 
> It seems like you could get this behaviour from issuing a
> poll/select(really?)/epoll as one of the async calls to complete.  (And you
> mention this in a later email? :))

Yes, no need for the above. We can just host a poll/epoll in an async() 
operation, and demultiplex once that gets ready.



- Davide


