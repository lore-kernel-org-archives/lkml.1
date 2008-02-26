Return-Path: <linux-kernel-owner+w=401wt.eu-S1763373AbYBZRIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763373AbYBZRIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763212AbYBZRIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:08:22 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:45921 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762994AbYBZRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:08:19 -0500
Date: Tue, 26 Feb 2008 09:08:07 -0800
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC] ext3 freeze feature ver 0.2
In-reply-to: <47C440A6.6080202@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Takashi Sato <t-sato@yk.jp.nec.com>, linux-ext4@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20080226170807.GE3172@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20080219202706t-sato@mail.jp.nec.com>
 <20080226172014t-sato@mail.jp.nec.com> <47C440A6.6080202@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 26, 2008  08:39 -0800, Eric Sandeen wrote:
> Takashi Sato wrote:
> 
> > o Elevate XFS ioctl numbers (XFS_IOC_FREEZE and XFS_IOC_THAW) to the VFS
> >   As Andreas Dilger and Christoph Hellwig advised me, I have elevated
> >   them to include/linux/fs.h as below.
> >     #define FIFREEZE        _IOWR('X', 119, int)
> > 　  #define FITHAW          _IOWR('X', 120, int)
> >   The ioctl numbers used by XFS applications don't need to be changed.
> >   But my following ioctl for the freeze needs the parameter
> >   as the timeout period.  So if XFS applications don't want the timeout
> >   feature as the current implementation, the parameter needs to be
> >   changed 1 (level?) into 0.
> 
> So, existing xfs applications calling the xfs ioctl now will behave
> differently, right?  We can only keep the same ioctl number if the
> calling semantics are the same.  Keeping the same number but changing
> the semantics is harmful, IMHO....

Do we know what this parameter was supposed to mean?

We could special case "1" if needed to keep compatibility (documenting
this clearly), either making it == 0, or some very long timeout (1h
or whatever).  A relatively minor wart I think.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

