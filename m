Return-Path: <linux-kernel-owner+w=401wt.eu-S1031663AbXEAMD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031663AbXEAMD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 08:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031679AbXEAMD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 08:03:28 -0400
Received: from sceptre.pobox.com ([207.106.133.20]:51786 "EHLO
	sceptre.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031663AbXEAMD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 08:03:27 -0400
Message-ID: <46372C8B.7090901@hp.com>
Date: Tue, 01 May 2007 08:03:23 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Reply-To: Alan.Brunelle@hp.com
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: CFQ IO scheduler patch series - AIM7 DBase results on a 16-way
 IA64
References: <4635D59C.4050300@hp.com> <20070430122753.GL21015@kernel.dk>
In-Reply-To: <20070430122753.GL21015@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Mon, Apr 30 2007, Alan D. Brunelle wrote:
>> The results from a single run of an AIM7 DBase load on a 16-way ia64 box 
>> (64GB RAM + 144 FC disks) showed a slight regression (~0.5%) by adding 
>> in this patch. (Graph can be found at   
>> http://free.linux.hp.com/~adb/cfq/cfq_dbase.png   ) It is only a single 
>> set of runs, on a single platform, but it is something to keep an eye on 
>> as the regression showed itself across the complete run.
>
> Do you know if this regression is due to worse IO performance, or
> increased system CPU usage?
We performed two point runs yesterday (20,000 and 50,000 tasks) and here 
are the results:

Kernel  Tasks  Jobs per Minute  %sys (avg)
------  -----  ---------------  ----------
2.6.21  20000     60,831.1        39.83%
CFQ br  20000     60,237.4        40.80%
                    -0.98%        +2.44%

2.6.21  50000     60,881.6        40.43%
CFQ br  50000     60,400.6        40.80%
                    -0.79%        +0.92%

So we're seeing a slight IO performance regression with a slight 
increase in %system with the CFQ branch. (A chart of the complete run 
values is up on  http://free.linux.hp.com/~adb/cfq/cfq_20k50k.png  ).

Alan
