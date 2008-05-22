Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbYEVCLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbYEVCLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 22:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYEVCLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 22:11:01 -0400
Received: from namei.org ([69.55.235.186]:39927 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbYEVCLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 22:11:00 -0400
Date: Thu, 22 May 2008 12:10:33 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@redhat.com>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       aviro@redhat.com, drepper@redhat.com, sds@tycho.nsa.gov
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
In-Reply-To: <483461DA.3060304@gmail.com>
Message-ID: <Xine.LNX.4.64.0805221210050.32056@us.intercode.com.au>
References: <1205346327.5297.232.camel@localhost.localdomain>
 <20080315215952.GB18676@devserv.devel.redhat.com> <20080317104537.GA32546@infradead.org>
 <483461DA.3060304@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Michael Kerrisk wrote:

> Christoph Hellwig wrote:
> > On Sat, Mar 15, 2008 at 05:59:52PM -0400, Alan Cox wrote:
> >>> does 11 really mean and should it really always be mapped to (FMODE_READ
> >>> | FMODE_WRITE) or should it continue to get mapped to 'no permission?'
> >> We've always mapped 3 to "no permission" to read or write. It's a linuxism
> > 
> > I've tripped over this recently aswell.  It would for sure be useful
> > to add a sumbolic O_FOO constant for this magic value '3' and document
> > it in the manpage.
> 
> Late follow-up to this thread
> (http://thread.gmane.org/gmane.linux.kernel/653123):
> I propose to add the following text to the open(2) man page.
> 
>        Unlike the other values that can be specified  in  flags,
>        the access mode values O_RDONLY, O_WRONLY, and O_RDWR, do
>        not specify individual bits.  Rather, they define the low
>        order  two bits of flags, and are defined respectively as
>        0, 1, and 2.  In other words, the combination O_RDONLY  |
>        O_WRONLY  is a logical error, and certainly does not have
>        the same meaning as O_RDWR.  Linux reserves the  special,
>        non-standard  access mode 3 (binary 11) in flags to mean:
>        check for read and  write  permission  on  the  file  and
>        return  a  descriptor  that  can't be used for reading or
>        writing.  This non-standard access mode is used  by  some
>        Linux  drivers  to return a descriptor that is only to be
>        used for device-specific ioctl(2) operations.
> 
> Seem okay?

Looks good to me.  We definitely need this documented.



- James
-- 
James Morris
<jmorris@namei.org>
