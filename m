Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbZALPqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbZALPqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbZALPqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:46:45 -0500
Received: from verein.lst.de ([213.95.11.210]:60994 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZALPqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:46:45 -0500
Date: Mon, 12 Jan 2009 16:46:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: new barrier warnings in 2.6.29-rc1
Message-ID: <20090112154634.GA15730@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whever a filesystem submits a bio with the barrier flag set but
the underlying hardware doesn't support it we now get errors in
the form of:

[ 3046.442629] end_request: I/O error, dev vdb, sector 0

since commit a7384677b2f4cd40948fd7ce024ba5e1821444ba which removed
the early check on the queue capabilities in __make_request.  I
think this message is pretty annoying and confusing for the user
as the filesystems already have more descriptive warnings, e.g. for
XFS:

[ 3046.455478] Filesystem "vdb": Disabling barriers, trial barrier write failed
