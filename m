Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZA3SlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZA3SlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753687AbZA3Sky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:40:54 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49772 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbZA3Skx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:40:53 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Jan 2009 10:40:51 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Pisa <pisa@cmp.felk.cvut.cz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] epoll fix own poll()
In-Reply-To: <200901301042.05333.pisa@cmp.felk.cvut.cz>
Message-ID: <alpine.DEB.1.10.0901301034370.31459@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271251310.20262@alien.or.mcafeemobile.com> <200901300329.35641.pisa@cmp.felk.cvut.cz> <alpine.DEB.1.10.0901292339480.16141@alien.or.mcafeemobile.com> <200901301042.05333.pisa@cmp.felk.cvut.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Jan 2009, Pavel Pisa wrote:

> I have seen the reason exactly when I have sent the e-mail
> and switched computer off at the night.
> 
> The reason is simple and it is caused by debugging print in each
> loop in my application and by way how poll concept is implemented
> in the kernel.

Yes, this is a known thing. Like I already told you yesterday, calling it 
a "spurious" event. So you code *is* generating a spurios event to the 
tty, with a write.
Unfortunately this is how Linux poll subsystem works. But things can be 
improved, w/out any revolution.
I already have patches to send Andrew-ward, that (gradually) uses the 
wakeup "key" to report event that really happened, during the wakeup call. 
This will allow the epoll callback to avoid epoll waiters wakeups, when 
events do not match the interest mask.


- Davide

