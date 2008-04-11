Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbYDKPlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbYDKPlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYDKPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:41:05 -0400
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:50919 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1759217AbYDKPlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:41:05 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sat, 12 Apr 2008 01:40:53 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [RFC] x86: Cleanup prose of Documentation/i386/IO-APIC.txt
Message-ID: <20080411154053.GD18242@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm doing a couple of cleanups to Documentation/i386/IO-APIC.txt
and I have a problem with this line, which is supposed to compute
a sample pirq= kernel parameter:

   echo -n pirq=; echo `scanpci | grep T_L | cut -c56-` | sed 's/ /,/g'

The 'scanpci' command used to be part of xutils and/or XFree86.
Xorg implements "Xorg -scanpci" but the output is different and it won't
run while X is running.

Firstly I propose using the $( ) construct rather than backticks, since
it is easier to read:

   echo -n pirq=; echo $( scanpci | grep T_L | cut -c56- ) | sed 's/ /,/g'

Inside the backtics, instead of scanpci, I could do:

   lspci -v | grep IRQ | sed -e 's/.* IRQ \(\w\+\)/\1/'

Is this an acceptable substitution?

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
