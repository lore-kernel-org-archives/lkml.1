Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbYCJIYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbYCJIYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbYCJIXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:23:54 -0400
Received: from phunq.net ([64.81.85.152]:50875 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYCJIXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:23:53 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Grzegorz Kulewski <kangur@polcom.net>
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Mon, 10 Mar 2008 00:23:51 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <Pine.LNX.4.63.0803100847000.3335@alpha>
In-Reply-To: <Pine.LNX.4.63.0803100847000.3335@alpha>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803100123.51395.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 March 2008 00:51, Grzegorz Kulewski wrote:
> > If UPS power runs out while ramback still holds unflushed dirty data
> > then things get ugly.  Hopefully a fsck -f will be able to pull
> > something useful out of the mess.  (This is where you might want to be
> > running Ext3.)  The name of the game is to install sufficient UPS power
> > to get your dirty ramdisk data onto stable storage this time, every
> > time.
> 
> Are you using barriers or ordered disk writes with physical sync in the 
> right moments or something like that? I think this is needed to allow any 
> journaling filesystem to do it's job right.

Usual block device semantics are preserved so long as UPS power does
not run out before emergency writeback completes.  It is not possible
to order writes to the backing store and still deliver ramdisk level
write latency to the application.

After the emergency writeback completes, ramback is supposed to
behave just like a physical disk (with respect to writes - reads will
still have ramdisk level latency).  No special support is provided
for barriers.  It is not clear that anything special is needed.

Daniel
