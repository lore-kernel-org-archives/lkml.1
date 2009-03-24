Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZCXJa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZCXJa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZCXJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:30:16 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:43442 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754102AbZCXJaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:30:14 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:CC:Subject:References:
   In-Reply-To:X-Enigmail-Version:Content-Type:
   Content-Transfer-Encoding;
  b=bzCl15WjNCh20SGuwnsjp5XcvexXY0xx9ywlefvf6IfKX1zYZy+I9cl6
   xy1JjPHlqRs3mw7/rrcKlbNaUMG+TBdl5WPOdfTUQvyjn3EFit301WnQq
   dML9UktZLM+tK5I;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,411,1233529200"; 
   d="scan'208";a="57396218"
X-IronPort-AV: E=Sophos;i="4.38,411,1233529200"; 
   d="scan'208";a="45468627"
Message-ID: <49C8A823.6020809@fujitsu-siemens.com>
Date: Tue, 24 Mar 2009 10:30:11 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: Improving IPMI performance under load
References: <49C27281.4040207@fujitsu-siemens.com> <49C2B994.7040808@acm.org> <20090319235114.GA18182@kroah.com> <49C3B6A5.5030408@acm.org> <20090320174701.GA14823@kroah.com> <49C3E03E.10506@acm.org> <49C78BE0.9090107@fujitsu-siemens.com> <49C7F368.5040304@acm.org>
In-Reply-To: <49C7F368.5040304@acm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

yesterday I posted some results about the IPMI performance under CPU 
load, which can be up to 25 times slower than in an idle system. I think 
it might be worthwhile to try to improve that behavior as well.

I made a variation of my patch which introduces a second parameter 
(kipmid_min_busy) that causes kipmid not to call schedule() for a 
certain amount of time. Thus if there's IPMI traffic pending, kipmid 
will busy-loop for kipmid_min_busy seconds, then starting to schedule() 
in each loop as it does now, and finally go to sleep when 
kipmid_max_busy is reached. At the same time, I changed the nice value 
of kipmid from 19 to 0.

With this patch and e.g. min_busy=100 and max_busy=200, there is no 
noticeable difference any more between IPMI performance with and without 
CPU load.

The patch + results still need cleanup, therefore I am not sending it 
right now. Just wanted to hear what you think.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
