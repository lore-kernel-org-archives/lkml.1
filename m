Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZEZRga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZEZRga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZEZRgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:36:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:24023 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZEZRgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,253,1241420400"; 
   d="scan'208";a="415780664"
Message-ID: <4A1C2895.7090902@intel.com>
Date: Tue, 26 May 2009 10:36:21 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Richard Atterer <richard@2009.atterer.net>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [Bug #13371] s2disk hangs with kernel 2.6.29 and later, SATA,
 Gigabyte EG45M-DS2H - culprit found
References: <GtY7d2eWpoK.A.ioC.MQcGKB@chimera> <20090525171305.GA5855@arbonne.lan> <20090525230259.GA5098@vilya> <200905260136.33724.rjw@sisk.pl>
In-Reply-To: <200905260136.33724.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 26 May 2009, Richard Atterer wrote:
>> Hello,
>>
>> "Jerry" contacted me off-list with information about the root of the 
>> problem - many thanks indeed!!!
>>
>> It turns out that the e100 driver is responsible. (The motherboard actually 
>> has a r8169 chip, but I added an old Intel PCI ethernet card I own.)
>>
>> By rmmoding e100 before s2disk, the problem goes away. Jerry mentions that 
>> he once saw a message about e100 failing to load its microcode - I never 
>> saw such a message.
>>
>> The most recent e100 commit ac7c992 by Thadeu Lima de Souza Cascardo (Apr 
>> 28) made some changes to the behaviour in the case of shutdown vs. suspend, 
>> maybe the problem is there? (But note that during bisecting, I tested 
>> kernels older than that commit, and not all of them worked.) Before that, 
>> f902283 (Mar 3 2008) mentions suspend in the log message.
> 
> OK, thanks for the information.  I'll have a look at the e100 suspend-resume
> code, but I really don't think commit ac7c992 is at fault here.

adding Jeff Kirsher to the Cc, who currently maintains the e100 driver.

Auke
