Return-Path: <linux-kernel-owner+w=401wt.eu-S934253AbYAaRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253AbYAaRSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbYAaRSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:18:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510AbYAaRSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:18:11 -0500
Message-ID: <47A202D0.1090303@redhat.com>
Date: Thu, 31 Jan 2008 12:18:08 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Lars Noschinski <lklml@ml.noschinski.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: How does ext2 implement sparse files?
References: <20080131152823.GA29422@lars.home.noschinski.de>
In-Reply-To: <20080131152823.GA29422@lars.home.noschinski.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Noschinski wrote:
> 
> Hello!
> 
> For an university project, we had to write a toy filesystem (ext2-like),
> for which I would like to implement sparse file support. For this, I
> digged through the ext2 source code; but I could not find the point,
> where ext2 detects holes.
> 
> As far as I can see from fs/buffer.c, an hole is a buffer_head which is
> not mapped, but uptodate. But I cannot find a relevant source line,
> where ext2 makes usage of this information.

In ext2 (and most other block filesystems) all files are sparse files. 
If you write to an address in the file for which no block is allocated, 
the filesystem allocates a block and writes the contents to disk, 
regardless of whether that block is at the end of the file (the usual 
case of lengthening a non-sparse file), in the middle of the file 
(filling in holes in a sparse file), or past the the end of the file 
(making a file sparse).

	-- Chris
