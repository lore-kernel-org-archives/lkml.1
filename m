Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbXEXSvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbXEXSvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXEXSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:51:15 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbXEXSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:51:13 -0400
Date: Thu, 24 May 2007 11:50:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Richard Purdie <richard@openedhand.com>
Subject: Re: [RFC] [-mm] Remove 'unsafe' LZO decompressor
Message-Id: <20070524115055.6be93924.akpm@linux-foundation.org>
In-Reply-To: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
References: <1412F214-FA89-4088-B3A2-DEE03C324FB6@cam.ac.uk>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 18:15:17 +0100
Michael-Luke Jones <mlj28@cam.ac.uk> wrote:

> Attached is a patch which may be desirable for -mm. It applies  
> directly to 2.6.22-rc2-mm1.
> 
> The patch removes the 'unsafe' LZO decompression function, lowering  
> the size of the minilzo.c file by nearly 500 out of an original 1727  
> lines. It also removes references to the 'unsafe' decompression  
> function in the public LZO header and the EXPORT_SYMBOL_GPL declaration.
> 
> This is intended to provoke some discussion over whether a  
> decompression function able to scribble on arbitrary memory is  
> desirable in the mainline kernel, whatever the performance increases.
> 
> Over and above the security/stability implications of using this  
> code, it can also be argued to represent an unnecessary duplication  
> of the vast majority of LZO decompression code. This is due to the  
> lack of likely in-kernel uses of the 'unsafe' function.
> 
> Only a single user for this 'unsafe' code has been suggested, the  
> 'Compressed Caching' project. This code is highly unlikely to move  
> into mainline in the same timeframe as the LZO code. All of the other  
> suggested uses require decompression of untrusted data, such that the  
> 'safe' function should be used.
> 
> Comments / disagreement all welcome :)

This is obviously a highly desirable thing to do for a number of reasons. 
But have we quantified the performance difference?
