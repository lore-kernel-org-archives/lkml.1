Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYEFFPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYEFFPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYEFFPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:15:31 -0400
Received: from fire.netis.ru ([193.233.48.99]:57072 "EHLO fire.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYEFFPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:15:31 -0400
X-Greylist: delayed 1012 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2008 01:15:30 EDT
Date: Tue, 6 May 2008 08:58:11 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: linux-kernel@vger.kernel.org
Subject: unkillable process during core dump
Message-ID: <20080506045811.GA23821@night.netis.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797709)
X-MailScanner-ID: m464wD7u020366
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=0,
	required 6, autolearn=disabled)
X-NETIS-MailScanner-From: lav@netis.ru
X-NETIS-MailScanner-To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have noticed that a process doing a core dump is unkillable.
Now imagine that there are many such processes and they are large.
An example:

#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
int main() {
        calloc(1000000000,1);
        signal(SIGCLD,SIG_IGN);
        while(1) {
                if(fork()==0) {
                        raise(SIGABRT);
                        _exit(0);
                }
                sleep(10);
        }
        return 0;
}

Try with large enough ulimit -c and with sysctl kernel.core_uses_pid=0.
You kill the parent, but the children are still doing their core dumps.

-- 
   Alexander.
