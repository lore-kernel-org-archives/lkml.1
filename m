Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZHCFEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZHCFEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 01:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZHCFEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 01:04:41 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:40312 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZHCFEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 01:04:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANoMdkqrR7PE/2dsb2JhbAC6BogpjgAFhBg
X-IronPort-AV: E=Sophos;i="4.43,312,1246838400"; 
   d="scan'208";a="222407368"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [ANNOUNCE] Reiserfs/kill-bkl tree v2
References: <20090731174642.GA6539@nowhere>
	<20090801081141.GA18036@basil.fritz.box>
	<20090801155335.GA4836@nowhere> <20090802142100.GA21160@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 02 Aug 2009 22:04:40 -0700
In-Reply-To: <20090802142100.GA21160@elte.hu> (Ingo Molnar's message of "Sun,
	2 Aug 2009 16:21:00 +0200")
Message-ID: <adatz0po5cn.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Aug 2009 05:04:40.0381 (UTC) FILETIME=[E80286D0:01CA13F7]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Well, dont waste too much time on it (beyond the due diligence 
 > level) - Andi forgot that the right way to stress-test patches is to 
 > get through the review process and then through the integration 
 > trees which have far more test exposure than any single contributor 
 > can test.
 > 
 > Patch submitters cannot possibly test every crazy possibility that 
 > is out there - nor should they: it just doesnt scale. What we expect 
 > people to do is to write clean patches, to test the bits on their 
 > own boxes and submit them to lkml and address specific review 
 > feedback.

I respectfully disagree in this case.  For patches that touch, say,
something hardware dependent where the patch submitter doesn't have all
the variations on the hardware, yes, I agree, scale the testing by
running the code on many machines.  But for the code in question, where
some very fundamental and complex changes are being made to filesystem
locking, I don't think that testing really scales -- after all, if there
is some race then it's quite likely that testers will just see some rare
filesystem corruption, which could easily waste weeks of debugging
before the BKL/reiserfs patches were even implicated.

 - R.
