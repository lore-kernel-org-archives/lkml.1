Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZGII1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZGII1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbZGII1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:27:00 -0400
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:49237 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753532AbZGII07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:26:59 -0400
Date: Thu, 9 Jul 2009 10:26:51 +0200
From: Dick Streefland <dick@streefland.net>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: simplification of scripts/extract-ikconfig
Message-ID: <20090709082651.GA6165@streefland.net>
References: <20090623225245.GA10443@streefland.net> <20090624021506.GA5871@cr0.nay.redhat.com> <20090624114607.GA10817@streefland.net> <20090624133148.GA12878@streefland.net> <20090629025146.GA5998@cr0.nay.redhat.com> <20090629113613.GA6853@streefland.net> <20090709023855.GA5648@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709023855.GA5648@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1MOoxw-0002Nx-Kj
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.322, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60, TW_IK 0.08)
X-ZiggoSMTP-MailScanner-From: dick@streefland.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2009-07-09 10:38, Amerigo Wang wrote:
| I appologize for my delay, I totally missed this thread, sorry.
| 
| I just tested it, it works! So,
| 
| Tested-by: WANG Cong <xiyou.wangcong@gmail.com>

Great, thanks.

| But, I still don't understand the behavior of 'grep -abo',
| please try the following commands:
| 
| echo -e '\x01\x02\x03\x04' > test.bin
| od -x test.bin
| tr $'\x01\x02\x03\x04' '1234' < test.bin | grep -abo '4'
| 
| Am I missing something here??

The output with grep-2.5.3 is 3:4, which means that the string "4" was
found at offset 3 (0-based). With grep-2.5.1, you get 0:4, which means
that the line containing the string "4" has offset 0. The "tr" commands
in the script ensure that the patterns we are looking for are always at
the start of a line, so that it doesn't matter which version of grep is
installed.

-- 
Dick
