Return-Path: <linux-kernel-owner+w=401wt.eu-S1751848AbZIUQlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbZIUQlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZIUQlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:41:14 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:43164 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZIUQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:41:13 -0400
Message-ID: <4AB7AAE2.8000404@ce.jp.nec.com>
Date: Tue, 22 Sep 2009 01:33:38 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
CC: device-mapper development <dm-devel@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
References: <4AB3B43D.9000802@ce.jp.nec.com>	<yq1eiq46ohz.fsf@sermon.lab.mkp.net> <4AB4F74E.7000908@ce.jp.nec.com> <yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1k4zt5o2f.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> Jun'ichi> Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of
> Jun'ichi> max_hw_sectors and the values of underlying devices are not
> Jun'ichi> propagated to the stacking devices.  
> 
> Well, max_sectors is already bounded by this.  max_hw_sectors only
> really matters for PC commands, so I'm not sure it's a big deal for
> DM. But I guess we could set the default max_hw_sectors to -1.
> 
> I'm just trying to avoid these scattered if-0-set-it-to-something-else
> cases.  I'd much rather have the defaults do the right thing.

I agree with that.
I had to do the if-0-set-it-to-something-else to avoid putting unnecessary
cap on max_hw_sectors.

If we aren't sure, shouldn't we set its default to -1 or putting comments
in blk_set_default_limits() at least to avoid possible confusion in future?

Thanks,
--
Jun'ichi Nomura, NEC Corporation 
