Return-Path: <linux-kernel-owner+w=401wt.eu-S937100AbYEBWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937100AbYEBWqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932450AbYEBWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:46:23 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:39598 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbYEBWqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:46:22 -0400
From: Roland Dreier <rdreier@cisco.com>
To: "Moore\, Eric" <Eric.Moore@lsi.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: HELP:  Is writeq an atomic operation??
References: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 02 May 2008 15:46:20 -0700
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B2F@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 16:40:40 -0600")
Message-ID: <ada63tw494z.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 May 2008 22:46:21.0166 (UTC) FILETIME=[577170E0:01C8ACA6]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Is a 64bit write to MMIO registers an atomic operation when using the
 > writeq API?  
 > 
 > My concern is when I send 64bit data via writeq, will it be sent out as
 > two 32 bit writes?  If so, is it possible that another CPU be sending
 > the data at the same time.  Meaning can I write the 1st 32bit data from
 > CPU-A, meanwhile CPU-B is writing his 32bit data at the same time, and
 > CPU-A didn't complete the full 64bit in one shot.  If this could occur,
 > is there an API that I can use to make sure the entire data sent in one
 > atomic operation?

I don't have an authoritative answer, but I can say that I coded
drivers/infiniband/hw/mthca and .../mlx4 assuming that writeq() is
atomic in the sense that you say, and no one has reported any problems.

But I'm sure no one has stressed the drivers on 64-bit mips or anything
unusual like that.

 - R.
