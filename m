Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbXEQV04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbXEQV04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbXEQV0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:26:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbXEQV0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:26:50 -0400
Date: Thu, 17 May 2007 22:26:41 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dedekind@infradead.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517212641.GU4095@ftp.linux.org.uk>
References: <20070517143200.GA30850@lst.de> <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de> <1179414590.3642.69.camel@sauron> <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517204234.GR4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 09:42:34PM +0100, Al Viro wrote:
> Ahem...  So what does
> 	x |= y;
> turns into with that approach?

Another case is

#define FLAG1 cpu_to_be32(2)
#define FLAG2 cpu_to_be32(0x400)

	if (packet_header->field & (FLAG1 | FLAG2))
		....

which is a bloody common idiom in net/* and it happens on some pretty hot
paths.  Approaches that would require converting it to something like
	if (be32_to_cpu(packet_header->field) & (FLAG1 | FLAG2))
would be not just obnoxious, they would actually generate worse code.
