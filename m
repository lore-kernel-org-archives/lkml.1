Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab0CHTeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:34:15 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63080 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0CHTeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jv5kdBZ/28KI8H7kePDYJydkSdGt0Dn+1oH1rm2f5R6ShAPAginiL6UPuwLLtfmqzy
         gfxHjSxCIs6N5UVnBTh+J9esKgRLpNUmwI/7U1iKr7unbTTxtj538afXsWlBAgb2Dvp4
         S9SO6/evcNzI7/FSwNSKsgsr00lqhNDVx8Mok=
MIME-Version: 1.0
In-Reply-To: <yq1zl2ic058.fsf@sermon.lab.mkp.net>
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net>
Date: Mon, 8 Mar 2010 14:34:08 -0500
X-Google-Sender-Auth: 98edb0ae30926079
Message-ID: <170fa0d21003081134g491034e5v4aad4d43853e48ec@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Mike Snitzer <snitzer@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 10:18 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
>
> Tejun> The [Windows Vista/7] partitioner seems to be using 1M as the
> Tejun> basic alignment unit and offsetting from there if explicitly
> Tejun> requested by the drive
>
> Yep.
>
>
> Tejun> Please note that hdparm is misreporting the alignment offset.  It
> Tejun> should be reporting 512 instead of 256 for offset-by-one drives.
>
> Already fixed.  Your hdparm must be old.
>
>
>
> Tejun> Partitioners maybe should only align partitions which will be
> Tejun> used by Linux and default to the traditional layout for others
> Tejun> while allowing explicit override.
>
> I don't think we take the partition type into account.  Karel?
>
>
> Tejun> Reportedly, commonly used partitioners aren't ready to handle
> Tejun> drives larger than 2 TiB in any configuration and alignment isn't
> Tejun> done properly for drives with 4 KiB physical sectors.  4 KiB
> Tejun> logical sector support is broken in both the kernel
>
> Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for ~2
> years.
>
>
> Tejun> (need more details and probably a whole section on partitioner
> Tejun> behaviors)
>
> I'm Cc:'ing Karel Zak and Jim Meyering who have been doing all the
> alignment work for fdisk and parted respectively.  Karel, Jim: The full
> writeup is here:
>
>        http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues
>
> It'd be great if you guys could share what you have been doing to the
> tooling.

I've been keeping track of all the pieces in play, have coordinated
with kzak and jim, and have a summary that offers some amount of macro
detail (at the end I touch on parted and fdisk):

http://people.redhat.com/msnitzer/docs/io-limits.txt
