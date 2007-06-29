Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbXF2H4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbXF2H4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 03:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761639AbXF2H4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 03:56:37 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:6607 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbXF2H4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 03:56:37 -0400
Date: Fri, 29 Jun 2007 11:56:32 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Cc: devel@openvz.org
Subject: filemap.c: interesting check around zero_length_segment:
Message-ID: <20070629075632.GA5926@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -W -Wno-stupid-warnings results in the following warning:

mm/filemap.c: In function 'generic_file_buffered_write':
mm/filemap.c:2179: warning: comparison of unsigned expression >= 0 is always true

		if (likely(copied >= 0)) {
			if (!status)
				status = copied;

Branch is always taken since "copied" is size_t.

Such code doesn't exist in -mm, but is this something to worry about for
current and older kernels?

