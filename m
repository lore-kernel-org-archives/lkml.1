Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZASQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZASQ5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 11:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZASQ5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 11:57:42 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:53859 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZASQ5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 11:57:41 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4974B107.6050701@gmail.com>
Date: Mon, 19 Jan 2009 16:57:43 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Regulator: Add a voltage changed event to notify consumers
References: <495FD46E.8040208@cam.ac.uk> <1231065078.11643.116.camel@vega.slimlogic.co.uk> <4973793D.60803@cam.ac.uk> <20090119152921.GA23444@rakim.wolfsonmicro.main>
In-Reply-To: <20090119152921.GA23444@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Sun, Jan 18, 2009 at 06:47:25PM +0000, Jonathan Cameron wrote:
> 
>> -out:
>> +	mutex_unlock(&rdev->mutex);
>> +	_notifier_call_chain(rdev, REGULATOR_EVENT_VOLTAGE_CHANGE, NULL);
>> +	return 0;
>> +out_unlock:
> 
> It'd be nice if we could modify _notifier_call_chain() to push the 
> locking out a bit so we don't need to drop the lock before calling the
> notifier.  On the other hand, for anything that isn't memory mapped or
> GPIO controlled (most regulators are in this category) the cost of the
> I/O is going to make this a non-issue.
Agreed.  On that note, isn't any call to regulator_force_disable
currently going to deadlock? (lock held in regulator_force_disable,
then re-called in _notifier_call_chain.)

I'll have a look into moving the locks out of _notifier_call_chain.

Jonathan

