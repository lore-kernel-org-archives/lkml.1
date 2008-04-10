Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYDJTXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYDJTXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYDJTXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:23:35 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:53431 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbYDJTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FIGkpKIiqJ47IkRGjaVFRuAG+tXePaoID7pD6r94m4TQPWkiOePA1KpCdNMHl11xkc7aaJHBPviq/iBqwDo646Cd4mX7a1nigSRc4pF7ZMg2wix8iKRE8LQhBz14mdcVgz6qnQJg20aS3nOu+pLomLtaRFyl1PnQhN1FbXqIn9I=
Message-ID: <38b2ab8a0804101223r7f072f39r2b69b79637a6c928@mail.gmail.com>
Date: Thu, 10 Apr 2008 21:23:32 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: Disk geometry from /sys
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080409212840.GB2160@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0804091353h3725ce29s196e27e8b4f1ff56@mail.gmail.com>
	 <20080409212840.GB2160@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 9, 2008 at 11:28 PM, Lennart Sorensen
<lsorense@csclub.uwaterloo.ca> wrote:
>  Many compact flash cards will report 16 heads, and 16 or 32 sectors
>  per track.  Compact flash can of course connect as an IDE drive, so they
>  are worth supporting (I keep trying to get the grub guys to accept my
>  patch to fix their code that also assumed all disks have 63 sectors per
>  track if they use LBA, but which is false since compact flash also
>  supports LBA even with smaller sizes).
>

Ok so assuming 255 heads seems not to be a good idea.

>  Simplest way to find out what geometry a disk pretents to have is to ask
>  fdisk,

or to create a new entry in /sys:

/sys/block/sda/geometry/heads

?

> and since the only use for the information is when creating
>  partitions, then fdisk's opinion is really all that seems to matter.  Of
>  course partitions can start and end anywhere so the total size is
>  actually all that really matters.
>

I'm not sure about that. Some bootloaders have constraint on the start
and end of a partition. It assume they're aligned on a cylinder size
boundary. I got this warning from sfdisk(8).

Thanks
-- 
Francis
