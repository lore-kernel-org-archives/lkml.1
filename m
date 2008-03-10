Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbYCKKGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbYCKKGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYCKKFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:05:53 -0400
Received: from gate.in-addr.de ([212.8.193.158]:36110 "EHLO mx.in-addr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750704AbYCKKFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:05:52 -0400
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Mar 2008 06:05:52 EDT
Date: Mon, 10 Mar 2008 22:03:52 +0100
From: Lars Marowsky-Bree <lmb@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Daniel Phillips <phillips@phunq.net>
Cc: Grzegorz Kulewski <kangur@polcom.net>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080310210352.GJ1581@marowsky-bree.de>
References: <200803092346.17556.phillips@phunq.net> <Pine.LNX.4.63.0803100847000.3335@alpha> <200803100123.51395.phillips@phunq.net> <20080310093737.3c1e938a@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080310093737.3c1e938a@core>
X-Ctuhulu: HASTUR
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-03-10T09:37:37, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Why - your chunks simply become a linked list in write barrier order.
> Solve your bitmap sweep cost as well. As you are already making a copy
> before going to backing store you don't have the internal consistency
> problems of further writes during the I/O.

You get duplicated blocks though. But yes, I agree - write-backs to the
disk must be ordered, other it's going to be too unreliable in practice.

An in-memory buffer for a log-structured block device.

> Yes you may need to throttle in the specific case of having too many
> copies of pages sitting in the queue - but surely that would be the set of
> pages that are written but not yet committed from a previous store
> barrier ?

You could switch from a journal like the above to a bitmap when this
overrun occurs. (Typical problem in replication.) SteelEye holds a
patent on that though, as far as I know.


Regards,
    Lars

-- 
Teamlead Kernel, SuSE Labs, Research and Development
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nürnberg)
"Experience is the name everyone gives to their mistakes." -- Oscar Wilde

