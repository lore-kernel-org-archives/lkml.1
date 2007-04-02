Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXDCUuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXDCUuf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbXDCUuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:50:35 -0400
Received: from iona.labri.fr ([147.210.8.143]:59100 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbXDCUue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:50:34 -0400
Date: Mon, 2 Apr 2007 22:42:02 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: mbind and alignment
Message-ID: <20070402204202.GC3316@interface.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

mbind(start, len, ...) currently requires that "start" be page-aligned,
but not "len" (which automatically gets page-rounded up).  This is a bit
odd:

- the userland type of start is void*, which people would expect to be a
  pointer to some variable.
- start needing to be page-aligned but len not needing to is not very
  consistent.
- none of this is documented in the manual page dated 2006-02-07

So one of those should probably be done to free people from headaches:

- document "start" requirement in the manual page
- require len to be aligned too, and document the requirements in the
  manual page
- drop the "start" requirement and just round down the page + adjust
  size automatically.

Samuel
