Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZCAOjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZCAOjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZCAOi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:38:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:43792 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZCAOi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:38:59 -0500
Date: Sun, 1 Mar 2009 14:38:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Feuerer <peter@piie.net>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] acerhdf: Acer Aspire One fan control
Message-ID: <20090301143851.GA11852@srcf.ucam.org>
References: <cone.1234471033.988571.5384.1000@mentalhome> <20090213134024.GA26549@srcf.ucam.org> <cone.1234551556.57236.4642.1000@onepiie> <20090213191815.GB1379@srcf.ucam.org> <cone.1235761090.678709.5345.1000@onepiie> <1235763653.24506.6.camel@localhost> <cone.1235847508.919525.5537.1000@onepiie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1235847508.919525.5537.1000@onepiie>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small number of things:

*) It looks like the patch has ended up linewrapped - it probably won't 
apply as a result.

*) x86 specific drivers are mostly moving from drivers/misc to 
drivers/platform/x86.

*) It should probably have a DMI modalias to allow it to autoload on 
appropriate hardware.

*) You have user and kernel modes - it should probably also have a bios 
mode that just leaves fan control in the same state it would be if the 
driver had never been loaded, and this should be the default.

*) The thermal code has been moved from ACPI into the generic thermal 
layer for 2.6.30. If you register thermal trip points and indicate that 
you require polling you should be able to get rid of the kernel thread 
in your driver and leave that up to the kernel.

Once that's all dealt with you should submit the patch to linux-kernel 
and Cc: Len Brown who maintains drivers/platform/x86. Include a 
description and a signed-off-by: line (and an entry in the MAINTAINERS 
file) and it should get merged.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
