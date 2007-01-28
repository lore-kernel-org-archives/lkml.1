Return-Path: <linux-kernel-owner+w=401wt.eu-S932837AbXA1VCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837AbXA1VCo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 16:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932846AbXA1VCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 16:02:43 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:50104 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837AbXA1VCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 16:02:43 -0500
Subject: Re: [Q] Prefered suspend to ram or disk method ?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Xavier Maillard <zedek@gnu.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200701282114.02539.rjw@sisk.pl>
References: <23972.1169975356@localhost> <200701282047.39997.rjw@sisk.pl>
	 <1170014258.25406.10.camel@nigel.suspend2.net>
	 <200701282114.02539.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 08:02:40 +1100
Message-Id: <1170018160.25406.30.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, 2007-01-28 at 21:14 +0100, Rafael J. Wysocki wrote:
> > Regarding the assumptions (about LRU pages not changing), I have that in
> > progress. The content of the LRU list definitely doesn't change, but by
> > calculating MD5 checksums of the changes before and after saving those
> > pages, we've seen some (up to 20) pages change on a few computers. I
> > need (obviously) to put time into finding the cause of those changes.
> 
> Do I understand correctly that you:
> - save the LRU,
> - copy data into them,
> - compute MD5 checksums of their contents,
> - save the image,
> - suspend,
> - resume,
> - load the image,
> - compute MD5 checksums of the loaded data,
> and the sums computed before saving the image and after loading it may differ
> for up to 20 pages?

No.

At the moment, I have an option that modifies the codepath so that prior
to saving the LRU, I calculate MD5 checksums for the LRU pages, then
prior to do the atomic copy (ie after saving them), calculate the
checksums again and compare. If the checksum varies, the relevant pages
are also resaved in the atomic copy and not restored from the LRU copy
when we reload the LRU pages at resume time. 

I want to put time into finding what changes the pages. I assume it's
filesystem or raid related because raid users also occasionally report
that raid code is submitting I/O after we've started saving LRU pages
(haven't had such reports from non-raid users).

Regards,

Nigel

