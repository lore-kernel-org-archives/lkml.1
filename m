Return-Path: <linux-kernel-owner+w=401wt.eu-S1760801AbYFXOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760801AbYFXOTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYFXOTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:19:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:18997 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbYFXOTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YTq7nWBDwNl5SOfbVswhyh0sBNHktCeXaTd0LxyR7/lP0f3FU9vOKMPLVf1qOQpK6h
         xmXdZ0EE0wMOyep5TQHOjouzw//9mo1rTwq7UKKpW9y4AMWYmumNjm+q+LEe0BCVmXyQ
         JDvRLG76ZdD2d+65rVJv+fosG2rim5P9ggpKs=
Message-ID: <58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
Date: Tue, 24 Jun 2008 16:19:27 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Cc: "Elias Oltmanns" <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
In-Reply-To: <20080624143548.24dcf511@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87k5gmz596.fsf@denkblock.local>
	 <200806240041.42796.bzolnier@gmail.com>
	 <87skv3s3d9.fsf@denkblock.local>
	 <200806241306.42054.bzolnier@gmail.com>
	 <20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	 <58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	 <20080624143548.24dcf511@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 3:35 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > I don't see why you think it's "hard". We have timeout handlers for many
>> > commands and those reset/abort just fine.
>>
>> They are different beasts from user-space initiated abort operation
>
> No they are not. They are the *same* thing in every respect.
>
> You have the drive in an unknown state, you want it back. If your drive
> lost a command due to noise or a firmware flaw you have no idea about the
> state it is actually in (supposed to be is irrelevant)

I generally agree with you w.r.t. to drive side of the operations but
the drive is only part of the equation (the host and the request states
are the others) so 'supposed to be is' is quite relevant.

Also abort request can happen i.e. while the command is being prepared
& issued (it is done without ide_lock being taken and the timeout is not
even armed yet) so there are additional issues to take care of.

IOW while the two operations are very similar on the drive level they
certainly have different needs and requirements at the higher level
(abort operation being especially tricky).

Thanks,
Bart
