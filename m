Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab0CKQeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:34:23 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:54054 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab0CKQeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AArndDgHIpbPcdxtsKV7oYbMPXXXj8PspOyzCtXq34AO29+KB4OQ/lPBFxB/jomvy2
         GcZB3NWGJy4L1sTbmc/NRqqn1HJY8ipomS15/yG56v9S81PEfVZEvIg7mi88PeQpqjmG
         mAkvL6hl1A/xwDtbOyFL+nRYUEBBYlWfaIG/A=
MIME-Version: 1.0
In-Reply-To: <20100311152551.GG1497@thunk.org>
References: <4B947393.2050002@kernel.org>
	 <472A4C80-30CE-4875-8073-F7E61659B6F0@mit.edu>
	 <1268318374.2798.2.camel@mulgrave.site>
	 <201003112035.26743.knikanth@suse.de>
	 <20100311152551.GG1497@thunk.org>
Date: Thu, 11 Mar 2010 11:34:21 -0500
Message-ID: <87f94c371003110834t37235274yc641258ac5939c24@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Greg Freemyer <greg.freemyer@gmail.com>
To: tytso@mit.edu, Nikanth Karthikesan <knikanth@suse.de>,
       James Bottomley <James.Bottomley@suse.de>,
       Damian Lukowski <damian@tvk.rwth-aachen.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       aschnell@suse.de, jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:25 AM,  <tytso@mit.edu> wrote:
> On Thu, Mar 11, 2010 at 08:35:26PM +0530, Nikanth Karthikesan wrote:
>> The real problem, here is just that partitioning-tools should create
>> partitions that can work with both XP as well as Windows7. May be distro
>> installers, should ask the user which compatibility he needs.
>
> 4k aligned sectors will *work* with Windows XP, will it not?  It's
> just simply a matter of Windows XP, being really ancient, doesn't
> create properly alligned partitions by default.
>
> And how often are we going to see Windows XP systems with these new 4k
> physical sector drives anyway, where the first OS to touch the
> partition is Windows XP?  And in the case where this does happy, the
> resulting partition will be result in terribly performance for Windows
> XP as well as Linux.
>
> What's the specific scenario which you are trying to solve, and how
> likely is it to occur in real life?
>
>                                        - Ted

Ted,

Apparently the real issue is Win2K, not XP.

It seems to require the boot partition and possibly all partitions
start on a cylinder boundary.  And may have 255/63 hard-coded in to
define what a cylinder is.  I agree with the apparent consensus that a
2010 era linux partitioner does not need to be Win2K compatible.  If
someone wants to install Win2K they will need to either use an older
generation partitioner to create the partitions or use specific
command-line args to force a non-optimal alignment.

I do think the linux partitioners should provide a way to force a
cylinder alignment.  Tejun, I would like to see your doc describe how
to force a win2k compatible partition layout.

fyi: The same issue apparently also exists for users still running OS/2.

Greg
