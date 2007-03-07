Return-Path: <linux-kernel-owner+w=401wt.eu-S932894AbXCGKNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894AbXCGKNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbXCGKNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:13:16 -0500
Received: from verein.lst.de ([213.95.11.210]:60827 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932890AbXCGKNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:13:14 -0500
Date: Wed, 7 Mar 2007 11:13:02 +0100
From: Christoph Hellwig <hch@lst.de>
To: xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] xfs: only use refcounted pages for I/O
Message-ID: <20070307101302.GA30587@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Many block drivers (aoe, iscsi) really want refcountable pages in
bios, which is what almost everyone send down.  XFS unfortunately
has a few places where it sends down buffers that may come from
kmalloc, which breaks them.  The patches in this series fix this
issue up.
