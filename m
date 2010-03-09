Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0CICvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 21:51:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:48312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0CICvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 21:51:52 -0500
Message-ID: <4B95B748.5080902@kernel.org>
Date: Tue, 09 Mar 2010 11:49:44 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Karel Zak <kzak@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Mark Lord <kernel@teksavvy.com>,
       tytso@mit.edu, "H. Peter Anvin" <hpa@zytor.com>,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <yq1zl2ic058.fsf@sermon.lab.mkp.net> <20100308195847.GC18077@nb.net.home> <4B95B39C.70402@kernel.org> <4B95B5A2.2090902@garzik.org>
In-Reply-To: <4B95B5A2.2090902@garzik.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Mar 2010 02:49:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/09/2010 11:42 AM, Jeff Garzik wrote:
> On 03/08/2010 09:34 PM, Tejun Heo wrote:
>> libata is broken for logical 4KiB ATA devices tho.  I'll fix it up.
> 
> Does libata-dev.git#sectsize miss any details?

I haven't looked at it yet.  I'll review it soon but the thing is
without actual hardware it would be a bit difficult to tell.  It's not
only the drivers.  I have this mighty unhappy feeling that some
controllers (especially some of the SATA ones with internal state
machine to emulate SFF) would be sniffing the commands and making the
wrong assumption if 4KiB logical sector size is used, so we'll need to
test various controllers.  Some PATA-SATA bridge chips will definitely
be having problems too.  Then there are the USB and other bridges too
but well those aren't libata's problem at least.  :-)

Thanks.

-- 
tejun
