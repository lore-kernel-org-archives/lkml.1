Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYCLR1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYCLR1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYCLR1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:27:32 -0400
Received: from phunq.net ([64.81.85.152]:45053 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751044AbYCLR1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:27:32 -0400
From: Daniel Phillips <phillips@phunq.net>
To: tvrtko.ursulin@sophos.com
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Wed, 12 Mar 2008 09:27:29 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <OFEE15880F.3018E689-ON8025740A.0041A021-8025740A.004203F5@sophos.com>
In-Reply-To: <OFEE15880F.3018E689-ON8025740A.0041A021-8025740A.004203F5@sophos.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803121027.30085.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 March 2008 05:01, tvrtko.ursulin@sophos.com wrote:
> linux-kernel-owner@vger.kernel.org wrote on 10/03/2008 06:46:16:
> 
> > Every little factor of 25 performance increase really helps.
> > 
> > Ramback is a new virtual device with the ability to back a ramdisk
> > by a real disk, obtaining the performance level of a ramdisk but with
> > the data durability of a hard disk.  To work this magic, ramback needs
> > a little help from a UPS.  In a typical test, ramback reduced a 25
> > second file operation[1] to under one second including sync.  Even
> > greater gains are possible for seek-intensive applications.
> 
> What about doing a similar thing as a device mapper target? Have a look a 
> dm-cache, I know that development of that has stopped but it doesn't mean 
> it couldn't be ressurected. It has an advantage that it is generic (any 
> two block devices will do) and you don't need to populate the "cache" on 
> start-up - it happens automatically through cache misses.

It is a device mapper target (though there is no real advantage in that
other than having a handy plug-in api).  It does handle any two block
devices, and it does populate on cache miss.  But also has daemon-driven
population, since it never makes sense to leave the backing disk idle
then have to incur read latency because of that later.

Regards,

Daniel
