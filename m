Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYBSXub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYBSXub (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbYBSXuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:50:18 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4104 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYBSXuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:50:16 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
From: "Michael Chan" <mchan@broadcom.com>
To: "Tony Battersby" <tonyb@cybernetics.com>
cc: "David Miller" <davem@davemloft.net>, herbert@gondor.apana.org.au,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <47BB54C2.6090501@cybernetics.com>
References: <47BA0984.2070306@cybernetics.com>
 <1203381120.13495.78.camel@dell>
 <20080218.163554.74130592.davem@davemloft.net>
 <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com>
 <1203448265.13495.95.camel@dell> <47BB54C2.6090501@cybernetics.com>
Date: Tue, 19 Feb 2008 15:52:43 -0800
Message-ID: <1203465163.13495.102.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6BA5B4BB3ZO5787033-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 17:14 -0500, Tony Battersby wrote:

> 
> Update: when I revert Herbert's patch in addition to applying your
> patch, the iSCSI performance goes back up to 115 MB/s again in both
> directions.  So it looks like turning off SG for TX didn't itself cause
> the performance drop, but rather that the performance drop is just
> another manifestation of whatever bug is causing the data corruption.
> 
> I do not regularly use wireshark or look at network packet dumps, so I
> am not really sure what to look for.  Given the above information, do
> you still believe that there is value in examining the packet dump?
> 

Can you confirm whether you're getting TCP checksum errors on the other
side that is receiving packets from the 5701?  You can just check
statistics using netstat -s.  I suspect that after we turn off SG,
checksum is no longer offloaded and we are getting lots of TCP checksum
errors instead that are slowing the performance.

