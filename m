Return-Path: <linux-kernel-owner+w=401wt.eu-S1764521AbYEGXOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764521AbYEGXOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbYEGXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:14:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:12520 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYEGXOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xllm39tR64yLU05gDamttv6pvlTsynxDKwra80V/QGbMtSRDoL3N369IDeYFsdbF73M8e/hYM4UHVn3RA+hGvSCLifHBQs2+69HvGUqJp279Hkoz/u+h6l8Nin8/4X+DAe5SXIH7XRpZU0bI2UpD22svkBf08Jd0ZGzX/ss0gkY=
Message-ID: <118833cc0805071614j49b10da6hfcbeb08cb3356afb@mail.gmail.com>
Date: Wed, 7 May 2008 19:14:33 -0400
From: "Morten Welinder" <mwelinder@gmail.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: Deleting large files
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <118833cc0805071249w36145eb6g7ed5c18d9fdf6fce@mail.gmail.com>
	 <Pine.LNX.4.61.0805071820010.25395@chaos.analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  Suppose you had an N GB file that just filled up the disk. You now
>  delete it, but get control back before it is really deleted. You
>  now start to write a new file that will eventually just fill up
>  the disk. [...]

That argument ought to stop right there.  If you believe that deleting a
file will necessarily and immediately give you back the space, then you
are wrong in the current state of the affairs already.

NFS does not do that -- in fact, I don't believe any file system does that
unless you can guarantee at least that no other process or the kernel has
that file open; AFS did not do that last I looked a decade ago; versioning
file systems do not; journaling file systems might not.  File systems that
support undelete do not do that.  In short: assuming such a thing is a
bug in need of a fix today.

Right now, unlink is a commonly used syscall with unbounded response
time.  If your GUI program deletes a file, the GUI generally locks up until
the kernel feels like returning -- that is certainly not how you get a smooth
user experience.  Forking a process to do the deletion (a) is pathetic,
(b) is not currently done, and (c) does not work: you cannot get a result
right away, i.e., you lose error handling.

Morten
