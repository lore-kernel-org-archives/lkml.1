Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbYCMUDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbYCMUDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYCMUDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:03:32 -0400
Received: from phunq.net ([64.81.85.152]:33931 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752203AbYCMUDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:03:31 -0400
From: Daniel Phillips <phillips@phunq.net>
To: David Newall <davidn@davidnewall.com>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 12:03:03 -0800
User-Agent: KMail/1.9.5
Cc: david@lang.hm, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803131232.07879.phillips@phunq.net> <47D9856E.9010304@davidnewall.com>
In-Reply-To: <47D9856E.9010304@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803131303.04118.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 12:50, David Newall wrote:
> Daniel Phillips wrote:
> > The period where you cannot access the data is downtime.  If your script
> > just does a cp from a disk array to the ram device you cannot just read
> > from the backing store in that period because you will need to fail over
> > to the ramdisk at some point, and you cannot just read from the ramdisk
> > because it is not populated yet.
> 
> Wouldn't a raid-1 set comprising disk + ramdisk do that with no downtime?

In raid1, write completion has to wait for write completion on all
mirror members, so writes run at disk speed.  Reads run at ramdisk
speed, so your proposal sounds useful, but ramback aims for high
write performance as well.

Daniel
