Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXI0SZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXI0SZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXI0SZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:25:11 -0400
Received: from pat.uio.no ([129.240.10.15]:53272 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbXI0SZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:25:09 -0400
Subject: Re: Floating Point Issue
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <109515.18343.qm@web7805.mail.in.yahoo.com>
References: <109515.18343.qm@web7805.mail.in.yahoo.com>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 14:25:04 -0400
Message-Id: <1190917504.6668.52.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.073)
X-UiO-Scanned: 9E36E17998542971FFA50A149C1B95946EF35E55
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 292 total 4154258 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 12:41 +0100, mahamuni ashish wrote:
> I have small code....
> 
> #include <stdio.h>
> #include <string.h>
> 
> int main()
> {
> float f= 1256.35;
> char ch[4];
> 
> printf("\n1. f : %f",f);
> memset(ch,'\0',strlen(ch) );
> printf("\n2. f : %f",f);
> return 0;
> }
> 
> Expected output is
> 1. f : 1256.35
> 2. f : 1256.35
> 
> But I am getting the output
> (on windows)
> 1. f : 1256.35
> 2. f : 0.000000
> 
> (on Linux)
> 1. f : 1256.35
> segmentation fault
> 
> why?

'cos 'strlen(ch)' isn't defined until you've initialised ch. If you swap
that line out with 'memset(ch, '\0', sizeof(ch))' then it will work.

Not a kernel bug, and hence not appropriate material for this list.

Trond

