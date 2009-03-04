Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZCDCMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZCDCMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZCDCMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:12:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:46942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbZCDCMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:12:22 -0500
Message-ID: <49ADE37E.1040000@kernel.org>
Date: Wed, 04 Mar 2009 11:12:14 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jgarzik@redhat.com>,
       saro_v@hotmail.it
Subject: Re: [patch 05/39] sata_nv: give up hardreset on nf2
References: <20090218212144.965748151@mini.kroah.org> <20090218213221.GF19814@kroah.com> <200903040053.36626.s.L-H@gmx.de>
In-Reply-To: <200903040053.36626.s.L-H@gmx.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 02:11:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Stefan.

Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Mittwoch, 18. Februar 2009, Greg KH wrote:
>> 2.6.28-stable review patch.  If anyone has any objections, please let us know.
> [...]
>> From: Tejun Heo <tj@kernel.org>
>>
>> commit 7dac745b8e367c99175b8f0d014d996f0e5ed9e5 upstream.
>>
>> Kernel bz#12176 reports that nf2 hardreset simply doesn't work.  Give
>> up.  Argh...
> 
> Sorry to report this rather late, but I upgraded a remote nforce3 system to
> 2.6.28.7 today, and noticed the following messages repeating continously 
> (reproducable on a different nforce3 system as well):
> 
> ata4: EH pending after 5 tries, giving up
> ata4: EH complete
> ata4: EH pending after 5 tries, giving up
> ata4: EH complete
> 
> Reverting just this patch from 2.6.28.7 lets them disappear again. Likewise
> 2.6.29-rc6-git7 is affected as well - and reverting this patch seems to fix
> the issue there as well. 

This is reported in bko#11615.  I don't quite understand it yet.  The
only thing that should have changed is the use of softreset instead of
hardreset and changing inheritance to nv_generic_ops should have done
exactly that in a very safe way.  Apparently, it didn't.  I'll dig
into what went wrong.

Thanks.

-- 
tejun
