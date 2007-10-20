Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbXJTBWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbXJTBWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXJTBWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:22:49 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:46502 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752303AbXJTBWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:22:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=v8DDks7sNvRDcE3QDJmboZvwx7p3F5PWM7yD+KdSUU/CWM/lvlgEHABBM7peYO0AxHkw/QfN45VmZErvBFCnIm1WkxIz0TpOnin/65vV3zEEp34lTve1QB3WVZ0PERPHpLYAgpdxD36BsluipjBb+BKKLDg6/i75f8Ls/3ZO+qM=  ;
X-YMail-OSG: l.xEyhQVM1l_haZWRjELhGWflRzM_a6C7qne2w.diUG6YCxL0B8s.qHxPfKoC6ftVANNpRKW8g--
Date: Fri, 19 Oct 2007 18:22:45 -0700
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-git Kconfig regression
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	(Originally posted to kbuild-devel per MAINTAINERS, but
	that post was rejected since that is -- undocumented,
	sigh -- a members-only list.)

Hi,

I noticed a regression, visible in the drivers/usb/gadget Kconfig;
it seems to be quite recent.

That Kconfig hasn't changed (other than adding new drivers), and
it's worked that way for several years now ... so the issue seems
to be changes in menuconfig/kconfig/etc semantics.

The issue is that when USB_GADGET=m, it's no longer possible to
configure peripheral controller drivers as modules ... the controller
drivers can now only be configured for static linkage.

It should be making a choice of one of the controller drivers which
could work on the target system, and allow that driver to be linked
either as a module (ok iff USB_GADGET=m) or statically.

What's the deal here?

- Dave

