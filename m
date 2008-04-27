Return-Path: <linux-kernel-owner+w=401wt.eu-S1764550AbYD0TzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764550AbYD0TzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 15:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763296AbYD0TyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 15:54:18 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763287AbYD0TyQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 15:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AlcYYAEA+4Kp2IuyhTnpIXgMAIPjzfqLsvxPXmjuCjW6LjNdc9JiEM88rAgfvXA4Ikn2hwiJVw2xIQewvYKy46/Ua/qRr0o91FS/OaGmJyWQVWu1PAakJb/Vf0fMGBEdsB9u2Bd97aGIJtQ8OVVtViEVlS3f8kqPCU9sDnxylV4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Date: Sun, 27 Apr 2008 20:32:51 +0200
User-Agent: KMail/1.9.9
Cc: "Roel Kluin" <12o3l@tiscali.nl>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
References: <48055F1A.9020706@tiscali.nl> <48072ED7.7030002@tiscali.nl> <9ea470500804170501s5e794cd2u8cda1b46fb6fbf9f@mail.gmail.com>
In-Reply-To: <9ea470500804170501s5e794cd2u8cda1b46fb6fbf9f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804272032.51371.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2008, Boris Petkov wrote:
> On Thu, Apr 17, 2008 at 1:04 PM, Roel Kluin <12o3l@tiscali.nl> wrote:
> > Boris Petkov wrote:
> >
> >  > I'd rather keep the "unsigned long bio_sectors;" part and do something
> >  > of the likes of:
> >  >
> >  > bio_sectors = bio_sectors(failed_command->bio);
> >  >
> >  >
> >  > (remove the "if (bio_sectors < 4)"-test)
> >  >
> >  > ... and later...
> >  >
> >  > sector &= ~(max(bio_sectors - 1, 3));

drivers/ide/ide-cd.c: In function ‘cdrom_analyze_sense_data’:
drivers/ide/ide-cd.c:180: warning: comparison of distinct pointer types lacks a cast

[ which actually hints us into real issue -> please think what would
  happen if bio_sectors() returns _zero_ before and after the patch ]

I applied the patch replacing the above code with:

	bio_sectors = max(bio_sectors(failed_command->bio), 4U);
	sector &= ~(bio_sectors - 1);

Thanks,
Bart
