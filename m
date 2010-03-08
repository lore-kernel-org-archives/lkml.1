Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0CHULz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 15:11:55 -0500
Received: from smtp2.ist.utl.pt ([193.136.128.22]:59134 "EHLO smtp2.ist.utl.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab0CHULt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 15:11:49 -0500
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2010 15:11:49 EST
Date: Mon, 8 Mar 2010 20:02:06 +0000
From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
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
Message-Id: <20100308200206.dac60db7.ctpm@ist.utl.pt>
In-Reply-To: <1268074705.10660.23.camel@mulgrave.site>
References: <4B947393.2050002@kernel.org>
	<1268031640.4389.11.camel@mulgrave.site>
	<yq1vdd6bzgz.fsf@sermon.lab.mkp.net>
	<yq1mxyibz7o.fsf@sermon.lab.mkp.net>
	<yq1iq96bz22.fsf@sermon.lab.mkp.net>
	<4B9546E6.6050006@zytor.com>
	<1268074705.10660.23.camel@mulgrave.site>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 09 Mar 2010 00:28:25 +0530 James Bottomley <James.Bottomley@suse.de> wrote:
> 
> There's another problem that afflicts 4k drives emulating 512b: they
> have to do a read modify write for any isolated 512b write ... that
> leads to potential corruption of adjacent 512b blocks if power is lost
> at the moment the write is being done.  Since most Linux filesystems are
> 4k sectors, misalignment really hammers this, plus most journal writes
> seem to be done in 512 byte increments.  I suppose for USB this could be
> regarded as flakey as usual, though.
> 

 Most users assume that a single 512B sector write is atomic as far as
power failure is concerned. Hasn't this requirement been carried over
to the new 4k physical sector?

 It seems reasonable that if a 512B sector write is atomic in the older
drives, a 4k sector write would also be atomic on the newer drives,
since the time required to write it is negligible when compared to
capacitor voltage decay and inertia of the disk platters.

 Anyway, I suppose most of the energy/time required for a sector write
operation, is being expended on head assembly positioning and the wait
for the correct sector passing under the write head. That is, the write
operation itself takes so little time that it should make no difference
whether you write 512B or 4k.

 So the question is: what are hard drive makers guaranteeing (if
anything at all)? Was a 512B sector write really atomic? Is a 4k one?
Or was it completely manufacturer-dependent to start?

 Regards

Cláudio

