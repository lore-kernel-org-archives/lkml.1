Return-Path: <linux-kernel-owner+w=401wt.eu-S1759592AbYBXQdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759592AbYBXQdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 11:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYBXQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 11:32:51 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:4403 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759386AbYBXQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 11:32:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=LFG4R8KFYJLLypR4vdPqTBjWMR5nL+JUiSOgN7yXxm7VXwvYS/a1+Y9uoDRMTN9rtEt6v+5tGdxaPdHr/ZOrQiDrI6QygHJHPJfqZpAfk2MNbFbs8qlwvKNGrXQ0eygHBCGciw8rWixJe9aYpocmyQwEpg2TQthgkkgNQ85Sc1c=
Date: Sun, 24 Feb 2008 17:32:44 +0100
To: Andreas Schwab <schwab@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Message-ID: <20080224163244.GA11998@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Andreas Schwab <schwab@suse.de>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
	j-nomura@ce.jp.nec.com
References: <jelk5k62uy.fsf@sykes.suse.de> <58cb370e0802180759h4d44b9bci86f02919a48c7979@mail.gmail.com> <20080218.135827.74754725.k-ueda@ct.jp.nec.com> <jek5kvisih.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jek5kvisih.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:47:50PM +0100, Andreas Schwab wrote:
> Kiyoshi Ueda <k-ueda@ct.jp.nec.com> writes:
> 
> > Could you try this patch?
> > I've only done a compile test, so this patch may not work.
> 
> Unfortunately, that is not enough to get DVD burning working again.
> This is the error that growisofs is getting:
> 
> ioctl(6, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[2a, 00, 00, 00, 03, 10, 00, 00, 10, 00], mx_sb_len=64, iovec_count=0, dxfer_len=32768, timeout=60000, flags=0x3, data[32768]=["\360R\360\314Wt\277\241\36.\347\356L$\201]\210\372_~]I\213\366\253SV\2\372\356\312\257"...], status=02, masked_status=01, sb[0]=[], host_status=0, driver_status=0, resid=32768, duration=0, info=0x1}) = 0
> write(2, ":-( unable to WRITE@LBA=310h: ", 30) = 30
> 
> It looks like the sense buffer is not filled in.  In a successfully run
> of growisfs under 2.6.24.2 the sense code is "LONG WRITE IN PROGRESS".
> 
> I also see that resid always equals dxfer_len even when the transfer was
> successful, although growisofs does not seem to care.  With 2.6.24.2
> resid is only non-zero when a sense error occurred.

Hm, strange,

burning a dvd here with growisofs works just fine. However, my
strace -v won't dereference the struct pointer passed to the ioctl:

...
open("/dev/dvd", O_RDWR|O_NONBLOCK|O_LARGEFILE) = 5
...
ioctl(5, SG_IO, 0xbf804d14)             = 0
...
-- 
Regards/Gruﬂ,
    Boris.
