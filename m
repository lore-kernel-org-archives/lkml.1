Return-Path: <linux-kernel-owner+w=401wt.eu-S934064AbXJOUFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064AbXJOUFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759302AbXJOUE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:04:57 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:36074 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbXJOUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qxfGCbCV5aESWynCjM664v0x+E/Tw+S/MdRbPKlhiK2hUF4XjdCf5yASOGC9CuDBLYj8V4NujrDajy3QgfTooCrUuJxk0Um7Aj4DlflJxlSHzxZgZUY9cAgDHKUE/MgvDw7ZjKoj0+eAt6q+tXT7+lJjsmftl/yx7rqtDxMH/I0=
Message-ID: <35fbaa3e0710151304k138f2ff1l90da195dcdefb96a@mail.gmail.com>
Date: Mon, 15 Oct 2007 23:04:54 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Cc: "Willy Tarreau" <w@1wt.eu>, gregkh@suse.de,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20071015103033.65b47dea.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
	 <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
	 <20071015103033.65b47dea.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete,

On 10/15/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> On Sun, 14 Oct 2007 23:45:36 +0300, "Vitaliy Ivanov" <vitalivanov@gmail.com> wrote:
>
> > Also IMHO the more drivers are in the tree the more users will use it.
> > Once it will be merged in the mainline then it will be backported to
> > enterprise kernels and would gain wide usage.
>
> At least in case of RHEL, such backports never were automatic. In any
> case, RHEL 2.1 and 3 do not receive new drivers anymore. We only do
> bugfixes if something comes up. Realistically speaking, 2.4 kernels
> are just too old for anyone to use. So, I think it would be best for
> you to think in terms of Willy's tree only.
>
> > +     in_end_size = le16_to_cpu(dev->interrupt_in_endpoint->wMaxPacketSize);
> > +     out_end_size = le16_to_cpu(dev->interrupt_out_endpoint->wMaxPacketSize);
>
> Did you verify if this works? We use pre-swapped descriptors in 2.4.
> I suspect you allocate 256 times more memory than necessary.
>
> > +static void adu_delete(struct adu_device *dev)
> > +     kfree(dev);
>
> > +static int adu_release_internal(struct adu_device *dev)
> > +     if (dev->udev == NULL) {
> > +             adu_delete(dev);
>
> > +static int adu_open(struct inode *inode, struct file *file)
> > +     retval = adu_release_internal(dev);
> > +     up(&dev->sem);
>
> The above very clearly is a use-after-free, in case the device was
> open across a disconnect. Solution: Use minor_table_mutex to lock
> dev->open_count instead of dev->sem. There's no rule that the lock
> has to live inside the same structure with members it locks.

Thanks for your notes. Will check and correct it asap.

Vitaliy
