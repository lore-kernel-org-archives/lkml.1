Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbXFDOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbXFDOFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbXFDOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:04:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:30223 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXFDOEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:04:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tnh4oTDglU/fAwKhAu37J+KQ/zh10nS0pTtqCFpihFEaGEHmqNFYglOzc1jFRNtLNY+Kiwu0I6OwcnUE5NE1TlS/5wBl4g1o+DeE5Km81+O87wyor+kERH/eGUITltWMXrCto9UgWSsPJcXh02ZRiLyprOi5fWefJJiGnnGZeqc=
Message-ID: <e7ca40f70706040704w450dd609g46b6e7a3689ff11@mail.gmail.com>
Date: Mon, 4 Jun 2007 10:04:52 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: slow open() calls and o_nonblock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070604144918.42354235@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <20070604144918.42354235@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> > Now, I'm a userspace guy so I can be pretty dense, but shouldn't a
> > call with a nonblocking flag return EAGAIN if its going to take
> > anywhere near 415ms?
>
> Violation of causality. We don't know it will block for 415ms until 415ms
> have elapsed.

Understood - but what I'm getting at is more the fact that there
really doesn't appear to be any real implementation of nonblocking
open().  On the socket side of the fence, I would consider a regular
file open() to be equivalent to a connect() call - the difference
obviously being that we already have a handle for the socket.

The end result, however, is roughly the same.  We have a file
descriptor with the endpoint established.  In the socket world, we
assume that a nonblocking request will always return immediately and
the application is expected to come back around and see if the request
has completed.  Regular files have no equivalent.

-Aaron
