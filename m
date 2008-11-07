Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYKGOrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYKGOrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYKGOqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:46:52 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:29258 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYKGOqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:46:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ELba1/gN1bAK+D0mB+fnUXHFL8jNkdAoxbQN/ejA8/T7zPdFXa4NAXdlDxvakyXC6E
         lDl9ek98lnldwZo7QyFMPXepKHcRIJPG3ZTl947xl1rDIEcdetXJ++6+p+y+kFtf2hcW
         DLlyRVCLEprVQfZ0RAEOyCkJfu0OtPFsUuetw=
Message-ID: <2c918050811070646y1bb5771bo70aff584252d7d1@mail.gmail.com>
Date: Fri, 7 Nov 2008 14:46:51 +0000
From: andy <rootstrap@googlemail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: accessing file operations directly in the kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <491397F2.6050106@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.8yqIDPH3sfvHfyr9YeQyeb9HG/Q@ifi.uio.no>
	 <491397F2.6050106@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree with you! But there are cases where standards
are followed from certain developers. I have to deal with a
very "peculiar" arrangement of a set of requirements to access
a serial device driver. The type of code below gives me what I need, I think.

filp = filp_open("/dev/device1", O_WRONLY, 0);

if (filp->f_op->ioctl(filp->f_dentry->d_inode, filp,
							CMD,
							(unsigned long) &args) != 0) {
        		goto failed;
}

Regards
Andy

On 11/7/08, Robert Hancock <hancockr@shaw.ca> wrote:
> andy wrote:
>
> > Hi,
> >
> > I am dealing with an interesting situation, which I have to access a
> > serial device driver
> > from the kernel space. I tried to use sys_open, sys_ioctl ... but
> > there is a problem
> > with the file descriptors.  Now, I started using direct calls to the
> > drivers functions
> > driver_open, driver_ioctl... passing the *inode from user_path_walk(),
> > but it doesn't
> > seem that works right. This serial device is going to be used only
> > from the other
> > module that runs in the kernel.
> >
>
>  For some reason this kind of question (using file operations inside the
> kernel) gets asked a lot. The short answer is that if you're asking it, you
> likely have a wrong design. It's just not the right thing to do. For one
> thing, file descriptors belong to a process, so just stealing the FD space
> from some random process is unlikely to do the right thing.
>
>  If you really need to do this, adding hooks to the serial device driver
> would seem a more logical thing to do.. but even that seems a suspicious
> design. It would be best if you explained what it is you're actually trying
> to accomplish.
>
