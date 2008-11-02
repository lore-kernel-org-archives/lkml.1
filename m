Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYKBUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYKBUlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYKBUlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:41:07 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:28217 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYKBUlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:41:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TrCIBFEDD3Z0GrIf55EfRW0wc7suolTdv4QPgb4ffEuW5QigMQaFDX4Mi4OvPpkevp
         0a4I/+AO2H+5xFbAY76pWUZe/lbLWo9jOVMH8bN9iQUqd7KWhPwKiuThqcsZschSt5DZ
         eXYJZJB/cVeTJWCr2y4APFt0AlsU+XmSuFc0I=
Message-ID: <b2cc26e40811021241t17a4fd02k32234b9e6b578b3b@mail.gmail.com>
Date: Sun, 2 Nov 2008 21:41:04 +0100
From: "Olaf van der Spek" <olafvdspek@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll behaviour after running out of descriptors
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0811021122530.9451@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b2cc26e40811010938k3864c48j45ce55af09516302@mail.gmail.com>
	 <Pine.LNX.4.64.0811021022120.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021033r115225e2x4747a17fc2b30256@mail.gmail.com>
	 <Pine.LNX.4.64.0811021047300.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021051kc748db3x44231dc0c085a8d6@mail.gmail.com>
	 <Pine.LNX.4.64.0811021117050.9451@alien.or.mcafeemobile.com>
	 <b2cc26e40811021120p1fa19892m4be6e00785b79289@mail.gmail.com>
	 <Pine.LNX.4.64.0811021122530.9451@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 8:27 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>> I know what TIME_WAIT is. I just think it's not applicable to this situation.
>
> It is. You are saturating the port space, so no new POLLIN/accept events
> are sent (until some TIME_WAIT clears), so epoll_wait() returns nothing
> (or does not return, if INF timeo).
> Keeping only 1K (if this is what you meant with your *only* 1K)
> connections *alive*, does not mean the trail that does moving 1K
> connections leave, is free.
> If you ever played with things like httperf, you should know what I'm
> talking about.

Wouldn't the port space require about 20+ k connects? This issue
happens after 1 k.
