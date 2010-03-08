Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0CHTMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 14:12:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36954 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576Ab0CHTMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 14:12:48 -0500
Message-ID: <4B954BF5.2050506@zytor.com>
Date: Mon, 08 Mar 2010 11:11:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	 <1268031640.4389.11.camel@mulgrave.site>	 <yq1vdd6bzgz.fsf@sermon.lab.mkp.net>	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>	 <yq1iq96bz22.fsf@sermon.lab.mkp.net>  <4B9546E6.6050006@zytor.com> <1268074705.10660.23.camel@mulgrave.site>
In-Reply-To: <1268074705.10660.23.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 10:58 AM, James Bottomley wrote:
>>
>> On the flipside, though, there really is very little net benefit to 4K
>> as opposed to 512 byte logical sectors: the additional protocol overhead
>> is relatively minimal, and as long as writes are aligned full blocks,
>> there shouldn't be any additional overhead on either the OS or the drive
>> side.  On the plus side, you get full compatibility with the existing
>> software stack.  The equation really seems rather simple.
> 
> There's another problem that afflicts 4k drives emulating 512b: they
> have to do a read modify write for any isolated 512b write ... that
> leads to potential corruption of adjacent 512b blocks if power is lost
> at the moment the write is being done.  Since most Linux filesystems are
> 4k sectors, misalignment really hammers this, plus most journal writes
> seem to be done in 512 byte increments.  I suppose for USB this could be
> regarded as flakey as usual, though.
> 

Misalignment sucks in general.  This is nothing new - the RAID and flash
people have had these problems for a long time now.  It's clear we need
to align our filesystems, period.

As to the read-modify-write issue: to some degree there is very little
you can do about it other than a big enough capacitor.  If you can't
write a sector atomically and have it stick, you're screwed no matter what.

	-hpa
