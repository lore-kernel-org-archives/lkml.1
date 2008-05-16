Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbYEPQy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbYEPQy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYEPQyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:54:21 -0400
Received: from testure.choralone.org ([194.9.77.134]:60846 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbYEPQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:54:20 -0400
Date: Fri, 16 May 2008 12:54:56 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: travis@sgi.com
Subject: x86-64 NODES_SHIFT compile failure.
Message-ID: <20080516165456.GA30854@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>, travis@sgi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4323838215184f5a2f081e0d17b8d60731b03164 added this line to x86's Kconfig..

 config NODES_SHIFT
        int
+       range 1 15  if X86_64
        default "6" if X86_64
        default "4" if X86_NUMAQ
        default "3"

Selecting 15 causes:

drivers/base/node.c: In function ‘node_read_distance’:
drivers/base/node.c:140: error: size of array ‘type name’ is negative

Should the upper limit be reduced to 14 (which compiles), or should
the BUILD_BUG_ON be changed to somehow cope with this set of changes?

	Dave

-- 
http://www.codemonkey.org.uk
