Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbXFDP7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbXFDP7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXFDP7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:59:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:7175 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbXFDP7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:59:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JDEym4CjKIcIj+Ss1ddGQdDx1O55mvFaJix7Qwic3mkysx8QOqOlwVUPcB2WaJzwEnKuqBE0WChAp8yHLQfFzzPo/QxFN+9sM5npCSaYDTmv5+w0kaABqZomofGlvgB1NMeXajhQApppE9u4hoycsGNbYX+A8QTayZZZF0zLOL4=
Message-ID: <e7ca40f70706040859g323d813fy3d7e741de8f190dc@mail.gmail.com>
Date: Mon, 4 Jun 2007 11:59:22 -0400
From: "Aaron Wiebe" <epiphani@gmail.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Subject: Re: slow open() calls and o_nonblock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1180971726.17737.36.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	 <e7ca40f70706040720k48aae8efg7a4997ce1d6f2450@mail.gmail.com>
	 <1180971726.17737.36.camel@heimdal.trondhjem.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
>
> So exactly how would you expect a nonblocking open to work? Should it be
> starting I/O? What if that involves blocking? How would you know when to
> try again?

Well, theres a bunch of options - some have been suggested in the
thread already.  The idea of an open with O_NONBLOCK (or a different
flag) returning a handle immediately, and subsequent calls returning
EAGAIN if the open is incomplete, or ESTALE if it fails (with some
auxiliary method of getting the reason why it failed) are not too far
a stretch from my perspective.

The other option that comes to mind would be to add an interface that
behaves like sockets - get a handle from one system call, set it
nonblocking using fcntl, and use another call to attach it to a
regular file.  This method would make the most sense to me - but its
also because I've worked with sockets in the past far far more than
with regular files.

The one that would take the least amount of work from the application
perspective would be to simply reply to the nonblocking open call with
EAGAIN (or something), and when an open on the same file is performed,
the kernel could have performed its work in the background.  I can
understand, given the fact that there is no handle provided to the
application, that this idea could be sloppy.

I'm still getting caught up on some of the other suggestions (I'm
currently reading about the syslets work that Zach and Ingo are
doing), and it sounds like this is a common complaint that is being
addressed through a number of initiatives.  I'm looking forward to
seeing where that work goes.

-Aaron
