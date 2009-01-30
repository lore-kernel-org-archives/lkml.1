Return-Path: <linux-kernel-owner+w=401wt.eu-S1754542AbZA3Jlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbZA3Jlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZA3Jld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:41:33 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:36260 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZA3Jlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:41:32 -0500
Subject: Re: Is there a way to set the order of initialization of different
	 systems ?
From: Jon Masters <jonathan@jonmasters.org>
To: George Kumar <grgkumar4@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5f695cd0901300103o31cb92f4o9feb8c598465617c@mail.gmail.com>
References: <5f695cd0901300103o31cb92f4o9feb8c598465617c@mail.gmail.com>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Fri, 30 Jan 2009 04:41:26 -0500
Message-Id: <1233308486.3937.113.camel@perihelion.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 01:03 -0800, George Kumar wrote:

> I would like to explore if there is a way so that I can set the order
> of initialization of different kernel sub systems. The main reason I
> would like to do this is because I have a network driver built
> statically in the kernel which wants to download firmware from the
> disk, but the IDE subsystem and root FS is not mounted yet so it
> basically hangs for a minute waiting to dowload firmware and then
> proceeds with the boot sequence. If I could ensure that IDE subsys is
> initialized and root FS is mounted before networking is initialized,
> this problem probably will not occur.

This is why we have initrds and similar. What you want is already done
quite successfully by a number of implementations in which the driver
will load, and cause a uevent to be emitted as it seeks firmware that
will be supplied to it. There's absolutely no reason for your driver to
be reading the firmware files directly from disk when we have
infrastructure like request_firmware around.

LWN wrote this article back in 2003: http://lwn.net/Articles/32997/

Jon.


