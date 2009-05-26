Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbZEZR2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbZEZR2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZEZR2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:28:05 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42091 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZEZR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=heR0N+h0jWD/upMFyxC/qOk95BsVE63KkBiK1KgFuy2+yxHnHoodHI74lMUdk7eyYT
         Q5vIujFnOWyY2gx79aP4jmpkET2Bxak75AgBmMNRuh4G6jmz4o7stoVC5wBRPTpynL8p
         sI56THq7qTltyd6CHuRoKnjLLBpWtCEGQzaQE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 1/3] ide: add "ignore_hpa" module parameter
Date: Tue, 26 May 2009 19:32:43 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc6-next-20090522-05935-g4d19128; KDE/4.2.3; i686; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905252344.11826.bzolnier@gmail.com> <200905261423.40117.bzolnier@gmail.com> <200905261453.22428.elendil@planet.nl>
In-Reply-To: <200905261453.22428.elendil@planet.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905261932.43657.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009 14:53:21 Frans Pop wrote:
> On Tuesday 26 May 2009, Bartlomiej Zolnierkiewicz wrote:
> > First time with the introduction of the default IDE HPA behavior of
> > always giving the access to the full capacity of a disk and leaving
> > decisions about HPA preservation/removal up to the installer & user.
> >
> > Second time when said distributions switched from IDE to libata (which
> > uses the different default behavior as it limits the capacity to
> > non-HPA part).
> 
> Has there really been something like a deliberate switch?

This heavily depends on distribution.

> In my experience with Debian there's been no such thing. ATA has just been 
> gradually enabled. (And initially that resulted in quite a mess because 
> some devices would be supported by two drivers and the kernel couldn't 
> even make up its own mind which one it preferred, resulting in random 
> switches between drivers. At least that was resolved at some point.)
> 
> However, I must admit that Debian has not handled the IDE-ATA switch very 
> well. So far users have mostly been left to deal with any fallout for 
> themselves.

I think that Debian still sticks to IDE (which is correct choice given
goals of this distribution).

> > Please note that no fancy sysfs support was needed to prevent the
> > problem: both stacks (ide & libata) support HDIO_DRIVE_TASK ioctl which
> > can be used to execute commands needed to retrieve/change HPA setting.
> 
> I don't really see how that would help. The fact that fancy ioctls exist 
> does not mean users or even distros have the knowledge needed to use 
> them. IMHO such issues should be dealt with at the level where that 
> knowledge is available: the kernel community.

The coordination from distributions was necessary and the answer from
some distributions was to continuously ignore or downplay the issue.

This has changed only recently with Tejun's work.

> > Moreover the (much needed) work from Tejun doesn't help a tiny bit in
> > case of people migrating their *working* setups from IDE to libata
> 
> From what I've seen now that seems the most important case that needs 
> supporting, as well as the case where a working setup would migrate from 
> IDE with old HPA default to IDE with new HPA default.

There is no IDE with new HPA default at the moment.
