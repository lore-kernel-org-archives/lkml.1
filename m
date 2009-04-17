Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbZDQXKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbZDQXKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755761AbZDQXKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:10:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48175 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZDQXKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:10:39 -0400
Date: Sat, 18 Apr 2009 00:10:10 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: 900af0d breaks some embedded suspend/resume
Message-ID: <20090417231009.GB6900@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms need to talk via I2C to power control devices during
the suspend method.  Currently, they do this via the platform PM ops
prepare callback, relying on the I2C driver being hooked into the
'late' suspend method, and hence being shut down _after_ the prepare
callback.

However, as of the above commit, the ordering is changed such that
platforms don't get notified of suspends until after all devices are
well and truely shut down.

This can't work, and actively breaks some platforms.

Please come up with another solution for your PCI problems, or provide
alternative equivalent functionality where the platform code is notified
of the PM event prior to the late suspend callback being issued.

-- 
Russell King
