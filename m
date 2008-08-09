Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbYHIPWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbYHIPWG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 11:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYHIPVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 11:21:53 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48720 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753172AbYHIPVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 11:21:52 -0400
X-Sasl-enc: LEAueuUM2QUVrQCwuKEF5dhgdhWNg/RH9MznqxCWM00p 1218295311
Subject: Re: [PATCH 1/4] autofs4 - cleanup autofs mount type usage
From: Ian Kent <raven@themaw.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20080809124739.GA16308@infradead.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com>
	 <20080809124739.GA16308@infradead.org>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 23:17:18 +0800
Message-Id: <1218295039.2994.49.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-08-09 at 08:47 -0400, Christoph Hellwig wrote:
> On Thu, Aug 07, 2008 at 07:40:06PM +0800, Ian Kent wrote:
> > Usage of the AUTOFS_TYPE_* defines is a little confusing and
> > appears inconsistent.
> 
> Not enough of an explanation for this patch.

OK, I'll re-submit this with an updated description.

> 
> It does:
> 
>  - move AUTOFS_TYPE_INDIRECT/AUTOFS_TYPE_DIRECT/AUTOFS_TYPE_OFFSET
>    to include/linux/auto_fs4.h.  Obviously okay but should mentioned
>    in the changelog.

So that user space can use consistent definitions.

>  - add a new, unused AUTOFS_TYPE_ANY constant. Why?

It is used by the later ioctl implementation patch.

>  - add a new AUTOFS_TYPE_TRIGGER and use it instead of
>    AUTOFS_TYPE_DIRECT or in one single case
>    (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET).  Definitively needs a good
>    explanation.

The direct and offset autofs mount types are, to a large extent, treated
the same way in the kernel module but are used a little differently in
user space. Previously, an offset mount had it's type set to
AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET but, the subsequent ioctl
implementation patch needs to be able to identify all three types of
autofs mount distinctly.

>  - replaces one use of sbi->type = 0 with AUTOFS_TYPE_INDIRECT (0x0001).
>    Why?

Previously, a type of 0 was implicitly assumed to be type
AUTOFS_TYPE_INDIRECT but that was not clear and doesn't lend itself to
clearly defined logic when trying to locate a specific type of autofs
mount in the later patch in the series.

Ian

