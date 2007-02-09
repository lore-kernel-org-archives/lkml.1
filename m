Return-Path: <linux-kernel-owner+w=401wt.eu-S1946302AbXBIKMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946302AbXBIKMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946299AbXBIKMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:12:52 -0500
Received: from twin.jikos.cz ([213.151.79.26]:37815 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946302AbXBIKMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:12:50 -0500
Date: Fri, 9 Feb 2007 11:11:52 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
cc: suparna@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Jan Kara <jack@suse.cz>
Subject: RE: [PATCH] aio: fix kernel bug when page is  temporally busy
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC804976@mssmsx411>
Message-ID: <Pine.LNX.4.64.0702091106100.25686@twin.jikos.cz>
References: <B41635854730A14CA71C92B36EC22AAC804976@mssmsx411>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007, Ananiev, Leonid I wrote:

> I have used EIOCBRETRY in the patch to minimize source code modification 
> only. It is notable that EIOCBRETRY is never set in kernel, but tested 
> only.

There is indeed something strange in aio in 2.6.20 (and maybe older) - for 
example do_generic_mapping_read() gets stuck inside lock_page() in the 
situation when the page is not up-to-date, instead of returning properl 
error to aio_run_cb().

Or does it work in some other way and I get it wrong?

-- 
Jiri Kosina
