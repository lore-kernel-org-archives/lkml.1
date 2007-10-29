Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXJ2LjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXJ2LjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXJ2LjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:39:09 -0400
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:21519 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752454AbXJ2LjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:39:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TJ1mpq5Pd17d3cWhWHRmxH9P80mQjuZFV+0I8VY+uhF11/3aE7bU4H0agVs1g/lXETZYtgtNtD1PkusY6XFw7cJCh7phrqAT/xFVvRAQfKx3CjGcmSKDUaItUCVkjHcB25VNc1fz4avW56jjSNuwqPBUvB8YLHkEZETjj9kZZGE=;
X-YMail-OSG: wUoTFIUVM1n6zZx3tEwRJ8.4Ge5THJBnW7X7j4xZWI4Efo7p.qDcrcgCvyhBmlXITcFB1X2mhse5YyPa4apToWkvFh6KP27vWkFyNMQnR_uVoy6.qgwHF1noD_s1FUuuA5MhuswDLKmZ9OU-
Date: Mon, 29 Oct 2007 11:39:05 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.1] PCI device locking up the computer when its module loads
To: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1193657365.19938.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <343473.92638.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Dan Williams <dcbw@redhat.com> wrote:
> This same sort of problem was just fixed for iwl4965.  The fix for that
> was to disable device interrupts until everything the driver needed
> (including interrupt handler) was set up and ready before re-enabling
> them, I think.  See the thread "iwl4965 detection problem" and the mail
> from Jes Sorensen on 2007-10-26.

The problem with this case is that pci_enable_device() is the very first thing that the driver
calls, but (as I understand it) I have no hope of sending commands to the device until this
function returns. This is a "catch 22" situation from my perspective, because how am I supposed to
know which device interrupt to disable if I can't call pci_enable_device()?

Does the 2.4 kernel survive because IRQs are disabled globally during module_init() or something?

Cheers,
Chris



      ___________________________________________________________ 
Want ideas for reducing your carbon footprint? Visit Yahoo! For Good  http://uk.promotions.yahoo.com/forgood/environment.html
