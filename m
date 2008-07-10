Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYGJFdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYGJFdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 01:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYGJFdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 01:33:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbYGJFdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 01:33:24 -0400
Date: Wed, 9 Jul 2008 22:27:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Lucina <mato@kotelna.sk>
Cc: linux-kernel@vger.kernel.org, Martin Sustrik <sustrik@fastmq.com>
Subject: Re: Higher than expected disk write(2) latency
Message-Id: <20080709222701.8eab4924.akpm@linux-foundation.org>
In-Reply-To: <20080628121131.GA14181@nodbug.moloch.sk>
References: <20080628121131.GA14181@nodbug.moloch.sk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jun 2008 14:11:32 +0200 Martin Lucina <mato@kotelna.sk> wrote:

> we're getting some rather high figures for write(2) latency when testing
> synchronous writing to disk.  The test I'm running writes 2000 blocks of
> contiguous data to a raw device, using O_DIRECT and various block sizes
> down to a minimum of 512 bytes.  
> 
> The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
> using ata_piix.  Write caching has been explicitly disabled on the
> drive, and there is no other activity that should affect the test
> results (all system filesystems are on a separate drive).  The system is
> running Debian etch, with a 2.6.24 kernel.
> 
> Observed results:
> 
> size=1024, N=2000, took=4.450788 s, thput=3 mb/s seekc=1
> write: avg=8.388851 max=24.998846 min=8.335624 ms
> 8 ms: 1992 cases
> 9 ms: 2 cases
> 10 ms: 1 cases
> 14 ms: 1 cases
> 16 ms: 3 cases
> 24 ms: 1 cases

stoopid question 1: are you writing to a regular file, or to /dev/sda?  If
the former then metadata fetches will introduce glitches.

stoopid question 2: does the same effect happen with reads?
