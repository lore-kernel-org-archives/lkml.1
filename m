Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbYEZI6E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbYEZI6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:58:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYEZI5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:57:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:49853 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYEZI5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:57:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=a9hToBjKc2Pkrn5djwL1DkHYJOj4/7W7agrwQZPkD85vGABTHVvz2HcU5cvS/BQ1CcQQKmtCyM9Asth83nSmw1zZA4MTRGQhJvfCmCCDwzGbZtiUHPU0lSbqIv6yCJXt36GKjqBhEUUPEoMHPiOuh8C1/fPL2eZHYQWCWB6ACGs=
Message-ID: <38b2ab8a0805260157k14d9a64dkeef48d230b978cf4@mail.gmail.com>
Date: Mon, 26 May 2008 10:57:54 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: question about splice performance
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
In-Reply-To: <4839D05C.4040309@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0805250812l2ecd424bh74a1694ed56460de@mail.gmail.com>
	 <4839D05C.4040309@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 25, 2008 at 10:47 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> If you drop caches you are not measuring splice speed.
>
> Use ramfs for your tests (guarantees data is in cache) instead.
>

So it seems that the gain when using splice to copy a file into another file
is very limited. Maybe that's the reason why cp is still using read/write...

Also splice-cp uses 2 calls to splice syscall in a loop. So it end up doing a
lot of syscalls. Maybe using sendfile instead of is better.

Also2, since splice is a generalized pipe, it might be better to create to
processes, one writing to the pipe and the other one reading to have better
workflow.

That said I also see some use cases where splice could be more useful,
specially when one of the file descriptor is actually a device: one the write
side of the pipes a device could write some data while on the other side of
the pipe a process can empty the pipe by writing the data to a file.

Are there any plans to improve splice interface to be used by drivers ?

Thanks.
-- 
Francis
