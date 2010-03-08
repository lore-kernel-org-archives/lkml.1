Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0CHVRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 16:17:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50160 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0CHVRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 16:17:20 -0500
Message-ID: <4B956940.1060304@zytor.com>
Date: Mon, 08 Mar 2010 13:16:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org>	<1268031640.4389.11.camel@mulgrave.site>	<yq1vdd6bzgz.fsf@sermon.lab.mkp.net>	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>	<yq1iq96bz22.fsf@sermon.lab.mkp.net> <4B9546E6.6050006@zytor.com> <yq1fx4aa7nq.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1fx4aa7nq.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 12:19 PM, Martin K. Petersen wrote:
>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
> 
> hpa> On the flipside, though, there really is very little net benefit to
> hpa> 4K as opposed to 512 byte logical sectors: the additional protocol
> hpa> overhead is relatively minimal, and as long as writes are aligned
> hpa> full blocks, there shouldn't be any additional overhead on either
> hpa> the OS or the drive side.  On the plus side, you get full
> hpa> compatibility with the existing software stack.  The equation
> hpa> really seems rather simple.
> 
> 4KB sectors are not a win for anybody except the drive vendors.
> 

Obviously.  However, larger physical storage unit sizes -- 4K for
spinning media, but frequently much larger for flash, for example -- is
already in wide use, and having a huge mishmash of logical block sizes
isn't going to work very well.

> There is a push in the industry right now to keep the 512-byte logical
> blocks forever.  The first step would be to report misaligned accesses
> or accesses that are not a multiple of the physical block size.  Second
> step would be to eventually reject any write that's not a properly
> aligned multiple of the physical block size.

I personally suspect that that is the way it is going to go, rather than
trying to change the software ecosystem to a different logical block
size.  It has been tried in the past and failed, with the sole exception
of CD-ROMs, pretty much.

	-hpa
