Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXHRTVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXHRTVT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbXHRTVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 15:21:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:53623 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbXHRTVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 15:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RLj9kGbNXZqehPCjp7DqH63/iu11+Z93tuYGA1q7UOTk1Pt3oWhVAPffuABGcfO3dzrbzk/D20gMJs2HiQxo078Pj49goSxWLDSL0/XCNm7qHIdsOvDePNPib6pIxYTKZPIfYtkc0fsffoXF2vkX0c5DXXo5s0zHfWolrwoiYg0=
Message-ID: <b2d05de20708181221t63eea603v43973edc53a5c5e0@mail.gmail.com>
Date: Sat, 18 Aug 2007 11:21:02 -0800
From: "Brennan Ashton" <comphappy@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: power off disk drives while running
Cc: "Marty Leisner" <leisner@rochester.rr.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708181815070.5186@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708181608.l7IG8Jmm006141@dell2.home>
	 <Pine.LNX.4.64.0708181815070.5186@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> On Aug 18 2007 12:08, Marty Leisner wrote:
> >
> >In embedded system design, it may be useful to poweroff the disks (as opposed
> >to merely spinning them down).  We want to leave the system running while
> >the disk is powered down, and let the disk powerup when it needs to be
> >spun up.
>
> That means you also have to power it on...
>
> >While the "power off mechanism" would be platform dependent, is there a
> >generic path to announce "prepare for power going away"?
>
> I do not see why that would be needed from a software point of view. Just make
> sure that the disk does not needlessy emergency-park when pulling power. When
> someone wants to write to disk, the request goes to the device driver, which
> hands it to the controller, which hands it to the disk. And your controller
> should be able to handle it (e.g. wait until reconnect) when there is a request
> for a disk that is powered off.
>
>
>         Jan
> --
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I see this a a very important feature in the embedded system relm, I
have worked on two projects that required extreme power management,
and massive data storage.  The ability to fully turn off a drive while
the system is running is key. It seems like this should be able to be
done from a kernel point of view rather than extra hardware. Although
if is not in the IDE/SATA spec then extra hardware would be necessary.
-- 
Brennan Ashton
Bellingham, Washington

"The box said, 'Requires Windows 98 or better'. So I installed Linux"
