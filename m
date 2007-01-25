Return-Path: <linux-kernel-owner+w=401wt.eu-S965601AbXAYW5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965601AbXAYW5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 17:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXAYW5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 17:57:52 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:44578 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965585AbXAYW5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 17:57:50 -0500
Date: Fri, 26 Jan 2007 01:56:34 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, Ulrich Drepper <drepper@redhat.com>,
       Andrew Morton <akpm@osdl.org>, netdev <netdev@vger.kernel.org>,
       Zach Brown <zach.brown@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Chase Venters <chase.venters@clientec.com>,
       Johann Borck <johann.borck@densedata.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Jamal Hadi Salim <hadi@cyberus.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org
Subject: Re: [take34 0/10] kevent: Generic event handling mechanism.
Message-ID: <20070125225634.GA9905@2ka.mipt.ru>
References: <1315adqaa0591036@2ka.mipt.ru> <11697329102169@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <11697329102169@2ka.mipt.ru>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Fri, 26 Jan 2007 01:56:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 04:48:30PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> Changes from 'take33' patchset:
>  * Added optional header pointer and its size into aio_sendfile_path(), 
>    which allows to send header and file in one syscall instead of
>    send(header), open file, sendfile(file).

Btw, aio_sendfile and aio_sendfile_path use naive and actually the 
simplest approach of async IO - it just stupidly blocks on sending or 
resends (like repeated sending approach) - I'm a bit lazy to use kevent 
there, since there is _no_ gain after a bit more deep analysis 
(hint: there are multiple IO threads, some of them might block), 
and network AIO does not exist (yet, kevent status is in hinged state,
and I was asked to postpone additional feature addons, which otherwise
could happen a bit more frequently then current kevent/kernel releases), 
due to kevent future is indeterminate...

-- 
	Evgeniy Polyakov
