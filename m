Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXCHQkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXCHQkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbXCHQkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:40:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:2780 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbXCHQkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e00XJ2PP7oSnf3WBasBMw2L2lKNgy76OQlT0GQ1mIghB0ZoMYmPu1x9ZLN9b7K/5PStmznhtq/U4LLqjNeIr1gKWo84gmivcm7tb5lW337J+Jf9IYh1WP4WoNzc1p+tnOe5K8yzNPp0K06/5FWCFCs3/C4s32D6vRXZLd9rHzHw=
Message-ID: <f2b55d220703080840xb0a1da0w41051a7c4a7ac4e3@mail.gmail.com>
Date: Thu, 8 Mar 2007 08:40:12 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "David M. Lloyd" <dmlloyd@flurg.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703071712210.3672@alien.or.mcafeemobile.com>
	 <1173364264.6891.3.camel@localhost>
	 <Pine.LNX.4.64.0703080742220.7015@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0703080812290.10832@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0703080825420.7015@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/8/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> The reason for the special function, was not to provide a non-blocking
> behaviour with zero timeout (that just a side effect), but to read the
> siginfo. I was all about using read(2) (and v1 used it), but when you have
> to transfer complex structures over it, it becomes hell. How do you
> cleanly compat over a f_op->read callback for example?

Make it a netlink socket and fetch your structures using recvmsg().
siginfo_t belongs in ancillary data.

The UNIX philosophy is "everything's a file".  The Berkeley philosophy
is "everything's a socket, except for files, which are feeble
mini-sockets".  I'd go with the Berkeley crowd here.

Cheers,
- Michael
