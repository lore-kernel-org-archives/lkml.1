Return-Path: <linux-kernel-owner+w=401wt.eu-S1750954AbXDWNQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750954AbXDWNQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXDWNQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:16:17 -0400
Received: from web36713.mail.mud.yahoo.com ([209.191.85.47]:34444 "HELO
	web36713.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750954AbXDWNQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:16:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=FNOua3/Q5byzoun9hQIjM+BRZ+G67VXq6cIBm6hc7wPzUyXmyo9qa0Bk1rxxhJGrMOM492zV1raUCImkl2Bp5iOVMNkQLgkpZS1GljUFSZA6JQ41vpvKftXQr+xR2AOGnBmH8T7dNuMxBw+vAb34vpYFyamou++3R+cAQazjnII=;
X-YMail-OSG: hEABxGsVM1kUGBVTV2kN5dX.h6ICy76MRmPTiPOM0Y0pjOF35KfF16RCwWAAIXtZA_fu.QjU9OtY9L.0q7X.sBWoREQJMS1Attaz
Date: Mon, 23 Apr 2007 06:16:16 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [mmc] alternative TI FM MMC/SD driver for 2.6.21-rc7
To: Sergey Yanovich <ynvich@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <5a04609e0704230029x56f08654v9d9d3fb1fef414ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <90215.57597.qm@web36713.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Sergey Yanovich <ynvich@gmail.com> wrote:

> > > For a typical, non-linux-geek user there are just two states of the device -
> > > available and not available. Ububtu is famous for its end-user support.
> > > They ship your driver since linux-2.6.17. But they pack it in one module.
> > > And that is _much_ easier, then a hotplug script.
> >
> > No, we ship a udev script.
> 
> OK, me bad for using the present tense. But you had a single module
> in Oct 2006, didn't you? And maybe, you would like to post the script.

Here's a simple udev rule that will do what you want:

SUBSYSTEM=="tifm", ACTION=="add", TIFM_CARD_TYPE=="SD", RUN+="/sbin/modprobe tifm_sd"

(just stick it somewhere in the udev rules).

You shall take into consideration that mmc currently lacks uevent support, so mmc_block must be
loaded manually (this is a long pending todo thingy; supposedly it waits for the first sdio
driver). There's no direct dependency of tifm_sd on mmc_block (only on mmc_core).

May be I'll add a modalias entry later so the explicit rule will not be needed.

As a side note: I have some very good reasons for the current driver architecture. You may want to
look them up in the mail archive (I outlined them during the initial driver submission).


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
