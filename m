Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZH0P3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZH0P3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 11:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZH0P3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 11:29:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47112 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZH0P3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 11:29:51 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Aug 2009 08:29:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Paolo Bonzini <pbonzini@redhat.com>, Avi Kivity <avi@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090827144905.GA22728@redhat.com>
Message-ID: <alpine.DEB.2.00.0908270752090.3809@makko.or.mcafeemobile.com>
References: <alpine.DEB.2.00.0908261201570.7780@makko.or.mcafeemobile.com> <1251363930-3916-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.00.0908270720250.3809@makko.or.mcafeemobile.com> <20090827143027.GA22720@redhat.com>
 <alpine.DEB.2.00.0908270732470.3809@makko.or.mcafeemobile.com> <20090827144905.GA22728@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009, Michael S. Tsirkin wrote:

> Oh, I stopped pushing EFD_STATE since we have a solution.
> I am just trying to grok what does and what does not consititute a
> use-once addition, in your mind, and what does and what does not
> belong in eventfd. The reason atomic does not belong there and
> semaphore does is because one waits on semaphore but not
> on atomic? Is that it?

An atomic variable is not a synchronization interface.
Even if it'd come up that we really need an atomic variable abstraction 
via an fd, this should not go via eventfd.
Yeah, maybe the name syncfd would have been better, but the very reason 
why eventfd born was to allow KAIO to signal events to poll/select/epoll.
That first implementation was also usable as a mutex.
Then it was propsed to make eventfd to act as a semaphore too. Code was 
trivial, a semaphore fitted the interface, and the abstraction was a 
pretty damn known too. So it went in.
Yes, you could have implemented a semaphore with the existing eventfd, by 
reading the counter and writing counter-1. But again, a semaphore was 
something widely known and generic enough, and was fitting the bill.


- Davide


