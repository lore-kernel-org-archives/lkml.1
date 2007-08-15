Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXHOCnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXHOCnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 22:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXHOCm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 22:42:59 -0400
Received: from gherkin.frus.com ([192.158.254.49]:33926 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056AbXHOCm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 22:42:59 -0400
X-Greylist: delayed 1185 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 22:42:58 EDT
Subject: [BUG] 2.6.23-rc3 won't boot on alpha
To: linux-kernel@vger.kernel.org
Date: Tue, 14 Aug 2007 21:23:12 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070815022312.A4073DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, I can't say where the bug was introduced, as this is
the first kernel I've tried on my Alpha since 2.6.22-rc7.  Best guess
is somewhere between .23-rc1 and .23-rc2, based on changes to files in
arch/alpha/boot in that patch set.  The problem happens early: aboot
starts to load vmlinux.gz, and I get an "unzip: invalid exec header"
error.  There's an earlier error from aboot I can't quote exactly, but
the template from aboot (bootlx) is:

aboot: Can't load kernel.
  Memory at %lx - %lx (chunk %i) is %s

The first %lx is all zeros.  The last %lx is all "F"s.  The chunk
number is 1, and I *think* the %s is "busy".

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
