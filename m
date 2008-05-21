Return-Path: <linux-kernel-owner+w=401wt.eu-S936570AbYEURzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936570AbYEURzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934846AbYEURzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:55:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:5648 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933225AbYEURzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:55:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=V7umG3dI+Ivio94skNmCvzEXALXVcqg5bhksW/VgljxYLGtblfi0yWISoRDPmx+URKfwcfiVSwFJE/NSt528Y7CqA+srD9UPnzqygwsjvZLOUEtx2DV85tNgPHe1YSBnQ9tyLpO+0Pr1ms+HrOUWNmaoMA57Rchqh74URyqeN/Q=
Message-ID: <483461DA.3060304@gmail.com>
Date: Wed, 21 May 2008 19:54:34 +0200
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Alan Cox <alan@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, aviro@redhat.com, drepper@redhat.com,
       sds@tycho.nsa.gov, jmorris@namei.org
Subject: Re: [RFC] correct flags to f_mode conversion in __dentry_open
References: <1205346327.5297.232.camel@localhost.localdomain> <20080315215952.GB18676@devserv.devel.redhat.com> <20080317104537.GA32546@infradead.org>
In-Reply-To: <20080317104537.GA32546@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sat, Mar 15, 2008 at 05:59:52PM -0400, Alan Cox wrote:
>>> does 11 really mean and should it really always be mapped to (FMODE_READ
>>> | FMODE_WRITE) or should it continue to get mapped to 'no permission?'
>> We've always mapped 3 to "no permission" to read or write. It's a linuxism
> 
> I've tripped over this recently aswell.  It would for sure be useful
> to add a sumbolic O_FOO constant for this magic value '3' and document
> it in the manpage.

Late follow-up to this thread
(http://thread.gmane.org/gmane.linux.kernel/653123):
I propose to add the following text to the open(2) man page.

       Unlike the other values that can be specified  in  flags,
       the access mode values O_RDONLY, O_WRONLY, and O_RDWR, do
       not specify individual bits.  Rather, they define the low
       order  two bits of flags, and are defined respectively as
       0, 1, and 2.  In other words, the combination O_RDONLY  |
       O_WRONLY  is a logical error, and certainly does not have
       the same meaning as O_RDWR.  Linux reserves the  special,
       non-standard  access mode 3 (binary 11) in flags to mean:
       check for read and  write  permission  on  the  file  and
       return  a  descriptor  that  can't be used for reading or
       writing.  This non-standard access mode is used  by  some
       Linux  drivers  to return a descriptor that is only to be
       used for device-specific ioctl(2) operations.

Seem okay?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

