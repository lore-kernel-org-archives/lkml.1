Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab0BUTMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 14:12:51 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:32939 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751571Ab0BUTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 14:12:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kEh3u4R6vDI6YiLrfYB1QrPlUaWd1CU3Dbl6YDI/f711EkRyDrYxz2J2S7UuHs8y/kCpyRwpsVpPbcmuceqLh2iFE1ciwzIsCetUeRZxiKxY+r1kJZtCYC4b0ozKZTJdO8KX2C0Z1nMbEkmjQQjrXxYcTwHYkNK9Ju6S8c3W854=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: hjwICDkVM1kug7PJnlgGigSvLogNDdPJ7PRN3t7nWKcPrazEsemKm04T2GhXu7WHU9bYuRb5dbuZls22.9ZKLKiZBj1a2oZDFb8qm6dKYRf48YhxOCYCXVr4nFinAcf.mi23phbSd0fgh1kp3vv1ui6dix8gxrvcfeOUakE7HVOGd4LBEyz8pgXjfLpFbWAS4EVXN5dUfMB6VbuofmG.7XIjIXxONydAEbjCJwju9llsB9dO8PYISLi5JFK7bYFsyAB.8skzm7WkNLa2pTIm_M0oXgTi0HFOM0XM4ummIVnB7CYiVeXPktM-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Denis Turischev <denis@compulab.co.il>
Subject: Re: [PATCH v3 3/3] gpio: add Intel SCH GPIO controller driver
Date: Sun, 21 Feb 2010 11:12:48 -0800
User-Agent: KMail/1.9.10
Cc: Samuel Ortiz <sameo@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
References: <4B73DAEE.5080400@compulab.co.il> <4B7C0DC3.3060907@compulab.co.il> <4B812C21.8000602@compulab.co.il>
In-Reply-To: <4B812C21.8000602@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002211112.48527.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 February 2010, Denis Turischev wrote:
> v2: there is no acpi_check_region, it will be implemented in mfd-core
> v3: patch refreshed against the latest Linus tree

Could such call really address the GPIO conflict issue I mentioned?

The AML bytecodes I looked at were writing directly to Southbridge
GPIO registers (or reading them), or relying on ACPI to mediate the
GPIO interrupts.  ISTR that button drivers, and code to switch into
or out of low power states, were good sources of such bad examples.

Calls like that should clearly be able to handle cases where ACPI
has a "Real" Driver (tm) ... e.g. for SMBus hardware.

I'm not sure what a good solution for this would be, short of just
not using ACPI ... which may not be practical, given the limited
degree of x86 board/system support for Linux.

I mention this mostly because when I looked at the issue in the
context of an ICHx GPIO driver, I didn't see a good solution to
the problem then ... and nothing seems to have changed meanwhile.

- Dave
