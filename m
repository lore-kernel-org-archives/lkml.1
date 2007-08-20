Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXHTMMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXHTMMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755223AbXHTML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:11:57 -0400
Received: from no-dns-yet.demon.co.uk ([83.105.13.114]:32910 "EHLO
	mailgate.netunix.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXHTML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:11:56 -0400
X-Greylist: delayed 1648 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Aug 2007 08:11:56 EDT
Message-ID: <46C97E7F.3010604@netunix.com>
Date: Mon, 20 Aug 2007 12:43:59 +0100
From: Chris Newport <crn@netunix.com>
Reply-To: crn@netunix.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7) Gecko/20040618
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Markus Dahms <mad@automagically.de>
CC: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible endless loop in PROM initialization
References: <20070820075949.GA5927@vimes.madsworld.lan> <20070820.010622.41634915.davem@davemloft.net> <20070820105320.GB4911@vimes.madsworld.lan>
In-Reply-To: <20070820105320.GB4911@vimes.madsworld.lan>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Dahms wrote:

>Hello again,
>
>David Miller wrote:
>  
>
>>When we boot the firmware provides a vector of function
>>pointers, and this is prom_nodeops.  So prom_nodeops->no_nextprop()
>>is a routine inside the PROM.
>>    
>>
>
>Thanks. So there is no real chance to fix it but to override this
>function?
>The strange thing is that the PROM prompt handles it correctly:
>
>| ok devalias scsi /iommu/sbus/espdma/esp
>| scsi isn't unique
>  
>
Non-unique devalias entries are NASTY. Get rid of them, for example
your second definition of scsi could be changed to scsidisk.
You should also check that any nvramrc entries do not cause conflicts,
it is common for nvramrc entries to refer to devalias entries, so you 
may need to also change an nvramrc entry to match any devalias change.

You can disable the use of nvramrc from the OBP prompt with
setenv if the entry isnon-essential, they are most commonly used
where there is a mirrored root disk.


