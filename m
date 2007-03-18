Return-Path: <linux-kernel-owner+w=401wt.eu-S1750799AbXCRUUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750799AbXCRUUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbXCRUUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:20:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:43589 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbXCRUUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:20:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AzhGv/JDiDkbGjK/G2O9FPEAmRZJ5x27/gIza/0VfuzMQzdVIEXIdJGtrXWuouZOCVyxnXXa93rC8TzuOisQWy4U84K5jpsea8DWRDQW6Z39S4y0R4V5FfJ+GTc0L4PM9BuuJjAjA/Ukrn/lx4h4KuCGvmwMSWDhLCBoMp1iWHc=
Message-ID: <170fa0d20703181320j59ee759dtbc0e3c7c916cd190@mail.gmail.com>
Date: Sun, 18 Mar 2007 16:20:33 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: forced umount?
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1174245379.3538.252.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <170fa0d20703162106v47dc13e1u1ae5381576f372ed@mail.gmail.com>
	 <1174245379.3538.252.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/18/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Fri, 2007-03-16 at 23:06 -0500, Mike Snitzer wrote:
> > I'm interested in understanding the state of Linux with regard to
> > _really_ forcing a filesystem to unmount.
> >
> > There is a (stale) project at OSDL that has various implementations:
> > http://developer.osdl.org/dev/fumount/
>
>
> the problem with the people who say they want forced umount is.. that
> most of the time they either want
> 1) get rid of the namespace entry
> or
> 2) want to stop any and all IO to a certain device/partition
>
> 1) is already supported with lazy umount (umount -l)
> for 2), it's not forced umount that they want, it's really an IO
> disconnect (which scsi supports btw in 2.6 kernels).
>
> So.. depending on which of the 2 you are, it's there. Just it's not
> called "forced umount".....

I'd be interested to know more about the IO disconnect support.  Do
you have any pointers on what interfaces are exposed to trigger such
an event?

The problem I'd like to solve is this:
A mounted blockdevice is considered "bad".  Given the device is "bad"
I don't care about flushing any outstanding IO.  I'd like the ability
to purge that blockdevice from the system; dropping all IOs on the
floor.  This would have to include invalidating inodes and more no?
Ultimately the superblock would need to be released too right?  Would
this happen for free with IO disconnect?

Does IO disconnect reliably and cleanly sever all associations a
mounted blockdevice has with Linux?
