Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbXBSMJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbXBSMJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932192AbXBSMJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:09:10 -0500
Received: from web36706.mail.mud.yahoo.com ([209.191.85.40]:25966 "HELO
	web36706.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932189AbXBSMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:09:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=D2c3r8yNZe0JaMTqTwNa0TXuhf+FZQOvE1LMS/cFiaoDBiY2sBXB/s8R0F9h3Ozi6GrtiXwbKzrblCIpsDeZ8HgpVQsjJ+cmpSiA6IvNIRtpyctTAc+5dgn8v/ag6WRSguZ1oOLuFY0ySKyohqCkA9rYAc5VajLQsfkKHEZiBX0=;
X-YMail-OSG: 9XKko3AVM1nuV62TV2PRSmNs0CsG4Etn4QwVrCDZn4DxeHMbacM4Y6065cwaYr2a1oZzOs.ENnQ9cm3kwlfLEOJObOcWnGRMBynKfIyOwonTsAE8f1Lceg--
Date: Mon, 19 Feb 2007 04:09:08 -0800 (PST)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Recent and not-so problems with tifm_sd driver
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45D94C70.1080802@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <570331.88389.qm@web36706.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> Alex Dubov wrote:
> > 
> > You'll agree, I think, that add_disk in mmc_block_probe issues a lot of requests (reads
> partition
> > table, fs superblocks and such - plenty of room for critical errors). Then, driver's remove
> method
> > will not be called before driver's probe method had finished. So mmc_block is quite involved,
> even
> > though it does not affect the problem's resolution.
> 
> I agree that mmc_block's probe method will generate a whole bunch of requests.
> But I don't see how that can be called given the scenario you describe.

mmc_rescan
  mmc_register_card
    device_add
      mmc_block_probe
        mmc_block_alloc
          -> queue thread starts running
        add_disk
          -> issues a lot of requests; card fails, my drivers calls mmc_remove_host, which in 
             turn calls device_del, though we are still in device_add



 
____________________________________________________________________________________
Have a burning question?  
Go to www.Answers.yahoo.com and get answers from real people who know.
