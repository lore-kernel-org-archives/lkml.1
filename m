Return-Path: <linux-kernel-owner+w=401wt.eu-S1422918AbXBAS2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422918AbXBAS2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422924AbXBAS2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:28:36 -0500
Received: from smtp-out.google.com ([216.239.33.17]:13557 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422918AbXBAS2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:28:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=haHf42iVqlmHGH9kZqfhABOeco7mwd8aPnCThk/8wT0h6y/RvwiOa8bkowdkfhXr7
	AJJy6yZoPehptHb/aclFQ==
Message-ID: <b040c32a0702011028n37715f12s391d1ac884917763@mail.gmail.com>
Date: Thu, 1 Feb 2007 10:28:25 -0800
From: "Ken Chen" <kenchen@google.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Subject: Re: Kernel BUG at fs/aio.c:509
Cc: "Andrew Morton" <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-aio@kvack.org
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC7CC56B@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070131231622.4ccdb2c1.akpm@osdl.org>
	 <B41635854730A14CA71C92B36EC22AAC7CC56B@mssmsx411>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Ananiev, Leonid I <leonid.i.ananiev@intel.com> wrote:
> >> BUG: warning at mm/truncate.c:398/invalidate_inode_pages2_range()
> >  That warning got removed from -rc7.
>
> 2.6.20-rc-7: After 57 minutes and after 25 minutes of aiostress running
> I've got 2 system hangs without any message in log.
> On the third time I opened the console and got kernel panic massage:

I think it would be worthwhile to put some instrumentation in
__aio_put_req to track last couple ref decrement for each aiocb.  My
hunch is that aio_complete() was called twice on the same aiocb.

    - Ken
