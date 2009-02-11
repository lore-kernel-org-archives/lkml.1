Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbZBKR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbZBKR5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 12:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZBKR5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 12:57:16 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:49045 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbZBKR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 12:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wIztH/iw/fmq71WoU0kYWHNE6W0uHdFPcoVYxJonQ1GeioSrDWbxf7jL/CER7HeTJe
         lkmUeLVJFf2//WfUprQrU47QDud3HR8rQLIdov1FfNxdQnxnKJD6eVHLP24GYTROIkGG
         VsvRABEGK3Vb3kyl02hqyCk5US66zFQDDQfHg=
MIME-Version: 1.0
In-Reply-To: <20090211171816.GA14516@fogou.chygwyn.com>
References: <2d42915c0902110255k3c0741a9s6830765bce6be052@mail.gmail.com>
	 <20090211133648.GA10273@fogou.chygwyn.com>
	 <2d42915c0902110637o2c0a88c7h72b280b972a6162e@mail.gmail.com>
	 <20090211171816.GA14516@fogou.chygwyn.com>
Date: Wed, 11 Feb 2009 20:57:12 +0300
Message-ID: <2d42915c0902110957i6c2f645cyfda572a64f19de64@mail.gmail.com>
Subject: Re: GFS2 file locking issues
From: Kirill Kuvaldin <kirill.kuvaldin@gmail.com>
To: steve@chygwyn.com
Cc: linux-cluster@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 8:18 PM,  <steve@chygwyn.com> wrote:
> cat /proc/mounts

/dev/mapper/gfsc-lvol0 /gfs2 gfs2 rw,hostdata=jid=0:id=720897:first=1 0 0

I also tried mounting explicitly specifying lockproto=lock_dlm, but it
didn't help.

Is my understanding of locking correct after all? Is that the case if
the process makes flock on a file, no other processes including ones
running on other cluster nodes could obtain a lock until the first
writer releases it?

>
> It should be listed in the options. That will also tell you if localflocks
> has been set as well. We do know of a bug in the GFS/GFS2 flock code though,
> it ought to be using an interruptible wait and it doesn't at the moment.
> Otherwise I don't know of any other issues.
>
> Which kernel version are you using?

2.6.18-92.el5xen (from CentOS 5.2)


Kirill
