Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbYFXTsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbYFXTsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 15:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYFXTsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 15:48:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708AbYFXTsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 15:48:09 -0400
Date: Tue, 24 Jun 2008 12:47:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [rfc patch 3/4] splice: remove confirm from
 pipe_buf_operations
In-Reply-To: <E1KBEFY-0002fh-5m@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LFD.1.10.0806241246240.2926@woody.linux-foundation.org>
References: <20080621154607.154640724@szeredi.hu> <20080621154726.494538562@szeredi.hu> <20080624080440.GJ20851@kernel.dk> <E1KB4Id-0000un-PV@pomaz-ex.szeredi.hu> <20080624111913.GP20851@kernel.dk> <E1KB6p9-0001Gq-Fd@pomaz-ex.szeredi.hu>
 <alpine.LFD.1.10.0806241022120.2926@woody.linux-foundation.org> <E1KBDBg-0002XZ-DG@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241129590.2926@woody.linux-foundation.org> <E1KBDpg-0002bR-3X@pomaz-ex.szeredi.hu> <alpine.LFD.1.10.0806241216350.2926@woody.linux-foundation.org>
 <E1KBE7p-0002eT-CJ@pomaz-ex.szeredi.hu> <E1KBEA8-0002ey-II@pomaz-ex.szeredi.hu> <E1KBEFY-0002fh-5m@pomaz-ex.szeredi.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Jun 2008, Miklos Szeredi wrote:
> 
> Or it can only happen if there was an I/O error on reading the page.

Now, IO errors are something else. They should have the PG_error bit set, 
and we should just return EIO or something.

That said, I'd not be surprised at all if error handling is broken. It's 
often been broken even in the _normal_ paths (ie totally normal "read()" 
etc).

		Linus
