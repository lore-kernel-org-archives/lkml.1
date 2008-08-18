Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYHRQyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYHRQyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYHRQy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:54:28 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:43036 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYHRQy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:54:28 -0400
In-Reply-To: <20080818171500.78590801@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, malware-list@lists.printk.net
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro	to a linux
 interface for on access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: douglas.leeder@sophos.com
Date: Mon, 18 Aug 2008 17:54:34 +0100
X-MIMETrack: Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 18/08/2008 17:53:31,
	Serialize complete at 18/08/2008 17:53:31
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080818165432.4E51C3F608D@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

malware-list-bounces@dmesg.printk.net wrote on 2008-08-18 17:15:00:

> > On async notification we fire a message to everything that registered
> > 'simultaneously.' On blocking we fire a message to everything in
> > priority order and block until we get a response.  That response 
should
> > be of the form ALLOW/DENY and should include "mark result"/"don't mark
> > result."
> 
> No can do - you get stuck with recursive events with the virus checker
> trying to stop the indexer from indexing a worm.

And the opposite approach can't work because the AV scanner + the index 
scanner 
need the HSM to do its work before they can scan.

I guess the only way it could work is to have levels:
e.g.
HSM agent is Level 1
AV scanner is Level 2
Index scanner is Level 3

When you register at Level N, you are excluded from all blocking/scanning 
at Levels >= N,
but your ops are still passed to Level < N.

An example is a little hard to craft because HSM and indexing catch 
different operations. :-)
 
-- 
Douglas Leeder

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.

