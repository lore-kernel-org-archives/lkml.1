Return-Path: <linux-kernel-owner+w=401wt.eu-S1757730AbXINLAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbXINLAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbXINLA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:00:29 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57980 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbXINLA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:00:28 -0400
Date: Fri, 14 Sep 2007 13:00:57 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: increase AT_VECTOR_SIZE to terminate saved_auxv properly
Message-ID: <20070914110057.GA10088@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

include/asm-powerpc/elf.h has 6 entries in ARCH_DLINFO.
fs/binfmt_elf.c has 14 unconditional NEW_AUX_ENT entries and 2
conditional NEW_AUX_ENT entries.
So in the worst case, saved_auxv does not get an AT_NULL entry at the
end.

Is an AT_NULL entry required or must userspace use the AT_VECTOR_SIZE
to not loop past the end of the array?
If AT_NULL is required, AT_VECTOR_SIZE should be changed from 44 to 46.

