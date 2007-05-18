Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbXERV0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbXERV0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbXERVZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:25:53 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:8995 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbXERVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:25:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DMfRZmtBM7mHTh42Zp15pYADWYGdYSbuW6uyLc20CicKyZY3rOHo8GVhEGfHwWlzMIXh2c/bgjzDubHOY3dZFOS81O6McoQyPDQ0Vw1Pea410NWjspIxhhVPcsQUUWJd/o39880v6eJDp9x530ilKJc7+DfKWBkUmeB4BfAATQ4=
Message-ID: <4af2d03a0705181425o1ba78307uef3deb4970bb954d@mail.gmail.com>
Date: Fri, 18 May 2007 23:25:52 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] Misc: phantom, move to unlocked_ioctl
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070518140314.4cabb926.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20644182862815412171@wsc.cz>
	 <20070518140314.4cabb926.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 18 May 2007 22:34:53 +0200 (CEST)
> Jiri Slaby <jirislaby@gmail.com> wrote:
>
> > @@ -118,7 +125,9 @@ static int phantom_ioctl(struct inode *inode, struct file *file, u_int cmd,
> >               if (r.reg > 7)
> >                       return -EINVAL;
> >
> > +             spin_lock(&dev->ioctl_lock);
> >               r.value = ioread32(dev->iaddr + r.reg);
> > +             spin_unlock(&dev->ioctl_lock);
>
> What is that locking protecting in here?

Well, what led me to do it is that I didn't know how much atomic are
ioread and iowrite. If concurrent process writes something to the
place in that space while the other one is reading it, doesn't matter,
correct?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
