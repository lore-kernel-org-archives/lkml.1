Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbZBOVCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbZBOVCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBOVCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:02:17 -0500
Received: from web110608.mail.gq1.yahoo.com ([67.195.13.199]:48024 "HELO
	web110608.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752738AbZBOVCQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:02:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mX6J8V3uyOGnTV5ttUu9cjWQcIS00i4WDY2lgy6bomyDL5IFbEgdQwuRjvp5aQSbcdwXv7rVNgtmQLT7y5Phqgbgd3KyuDw0V0qVRZYxcfqacfEZ/IA+AnpwbM/GsVacoRlTwl8Sh6oSgk6gWrpTUtXF0m02W9GBnNPnWrwurO0=;
X-YMail-OSG: F_JO3dsVM1nM70JuTH57sbNwb3yRB10bRYcztTb4sxnptwehOHjtvpSmoocuj_.lduBraTF9yHH8U75HQd7SLXiGsL1UGOsrPqC6q91u4CezcisSC_Qiv555_MxNhZj3RKsX0XE.bgu.YHm69OpUVruvu6Zdbmq0rTQ3rmv0YAiwpJZGQ0NhEYBBq1LOX7lzGPVt9ZBNCrFEb3fNmHl77naVkST7UGHyt.OLcn1PlZ7s54qLlesdBoOOuHyGyHHlqMtZu36b852Na2BfrGpyZRkdNqDPE3h7H6hGEyU-
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.260.1
References: <slrngpgfil.5gc.sitsofe@sitsofe.eeepc.localdomain> <20090215170214.GK5835@nowhere> <883216.75749.qm@web110607.mail.gq1.yahoo.com> <20090215194147.GB5790@nowhere>
Date: Sun, 15 Feb 2009 13:02:15 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Poking ieee80211_default_rc_algo causes kernel lockups
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <690182.5203.qm@web110608.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Frederic Weisbecker <fweisbec@gmail.com>

> 
> On Sun, Feb 15, 2009 at 11:24:41AM -0800, Sitsofe Wheeler wrote:
> > > Could you please enable the CONFIG_DETECT_SOFTLOCKUP option in your kernel?
> > 
> > > It's on Kernel Hacking > Detect Soft Lockups.
> > > With some chances you will have a relevant stacktrace of the lockup, in case
> > > I couldn't reproduce it.
> > 
> > I'll try (the kernel I'm currently using is jam packed with with debug 
> options) but I'm unconvinced it will unfreeze enough for anything useful...
> 
> No need to actually, I guess we found it...

That's good news - the only way I could have reported the soft lockup stack trace would have been by taking a photo of the screen. The stack trace was pretty much what is seen inside <http://groups.google.com/group/fa.linux.kernel/browse_frm/thread/d4a6ce26360613fa/b362792a2debced6?#b362792a2debced6> anyway. The thing that I'm curious about is why did it show up as an oops last time and as a complete lockup this time?

My one thought is that this is actually a parameter that was not intended to be changed and shouldn't have accepted being written to. However one wonders how the syfs framework was supposed to work in other cases. It sounds like there is a very small window for making your own private copy of whatever sysfs passes to you and under the current system who throws away old strings (given that it looks like pointers are being swapped)? Are they refcounted or something?



      
