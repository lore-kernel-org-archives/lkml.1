Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYAPRle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYAPRle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYAPRlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:41:25 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36606 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYAPRlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:41:24 -0500
Subject: Re: [PATCH 04/27] kill filp_open()
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, Bryn Reeves <breeves@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
In-Reply-To: <20080116171032.GA24300@infradead.org>
References: <20071101230826.9A4F6E00@kernel>
	 <20071101230831.904FDE9A@kernel>
	 <20080116005200.0165dc67.akpm@linux-foundation.org>
	 <1200503096.22674.171.camel@localhost>
	 <20080116171032.GA24300@infradead.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 09:41:12 -0800
Message-Id: <1200505272.22674.176.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 17:10 +0000, Christoph Hellwig wrote:
> 
> But ultimatively I think we should remove this silly renaming from
> the patch.  It doesn't help the goal and just created churn, so please
> rename open_namei back to do_filp_open for now and put filp_open back.

It wasn't really a rename.  More that I ended up moving everything
useful the filp_open() did to other functions, so I didn't see the need
to keep around a stub like this:

 struct file *filp_open(const char *filename, int flags, int mode)
 {
	return open_namei(AT_FDCWD, filename, flags, mode);
 }

It would be trivial to add this stub back, though.

-- Dave

