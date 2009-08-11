Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZHKQq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZHKQq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZHKQq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:46:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:48950 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZHKQq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:46:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANs9gUqrR7O6/2dsb2JhbAC7EIgrkCwFhBk
X-IronPort-AV: E=Sophos;i="4.43,361,1246838400"; 
   d="scan'208";a="365170012"
From: Roland Dreier <rdreier@cisco.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 12/14] scsi: use printk_once
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
	<1249847649-11631-13-git-send-email-marcin.slusarz@gmail.com>
	<1250008813.4301.55.camel@mulgrave.site>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 11 Aug 2009 09:46:48 -0700
In-Reply-To: <1250008813.4301.55.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 11 Aug 2009 11:40:13 -0500")
Message-ID: <adahbwe70xz.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Aug 2009 16:46:58.0095 (UTC) FILETIME=[57596BF0:01CA1AA3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > -	static int vers_printed;
 > > -
 > > -	if (!vers_printed) {
 > > -		printk(KERN_INFO "%s", version);
 > > -		vers_printed = 1;
 > > -	}
 > > +	printk_once(KERN_INFO "%s", version);

 > There's really no point to this beyond code churn.  Both patterns are
 > correct uses so conversion buys us nothing.

It's a pretty small gain but I do think 6 lines -> 1 line does have value.

 - R.
