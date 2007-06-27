Return-Path: <linux-kernel-owner+w=401wt.eu-S1759993AbXF0FCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759993AbXF0FCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXF0FCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:02:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:43475 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbXF0FCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:02:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NGPqoH+DnhaOK6JiOAV9bu59VcuiRgQH+79M9HAZKzuwaMnfkGFCvrixA7kdyCUdpzh3jAUgtfuyiU+JY/ZWee8oKaJl9m3Dg10vzDxYmSar6/zGraaWQW01BGv6QFMyZqcjWNWxf8KYm1dkZ71jQJjenBg+s+j7pn8i3sthZ64=
Message-ID: <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com>
Date: Tue, 26 Jun 2007 22:02:33 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2>
	 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com>
	 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> I acutally have the code for it, but I never posted it since it did not
> receive a too warm review (and the only user was the fdmap thingy).

Only user of sys_indirect?  There will be quite a few right away.
Every syscall that returns a file descriptor needs O_CLOEXEC support
(socket, pipe, epoll_create, ...)


> OTOH glibc could implement __morecore using mmap(MAP_NOZERO), and hence
> brk2() would not be needed, no?

No.  mmap calls create individual VMAs which gets expensive.  There
are also some hardware drivers which get more expensive the more VMAs
there are.  I want to go away as much as possible from mmap for
malloc.
