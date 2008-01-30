Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYA3AVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYA3AVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYA3AU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:20:58 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:55175 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbYA3AU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:20:56 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Jon Masters <jonathan@jonmasters.org>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <1201641765.18773.35.camel@dv>
References: <1201641765.18773.35.camel@dv>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 29 Jan 2008 19:20:20 -0500
Message-Id: <1201652420.2271.91.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 16:22 -0500, Pavel Roskin wrote:
> Hello!
> 
> It have come to my attention that a patch has been committed to the
> kernel with the explicit purpose of tainting ndiswrapper - the kernel
> module allowing Windows NDIS drivers for Ethernet and Wireless cards to
> be used by the kernel.
> 
> That's the commit in question:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0aa5bd52d0c49ca56d24584c646e6544ccbb3dc9

Yup. There was (what I thought was) a bug in the existing logic (an
explicit match on "ndiswrapper", and a setting of the global kernel
taint flags) and I corrected it to do what I thought it was actually
intending to do, but hadn't been. Was I mistaken? What's the point of
setting the global taint if we don't know why we set that?

> - ndiswrapper is licensed under GPL

Yes it is. But I thought the existing code was intending to taint the
kernel (that's what it does), so it would really help to identify why it
tainted the kernel, by calling add_taint_module instead of add_taint. I
didn't put the existing match in there...don't shoot the messenger :)

> - ndiswrapper needs GPL-only symbols

Another fix would be for ndiswrapper to explicitly set the taint when it
loads a tainted driver? Or do we just want to go back to globally
"tainting" the kernel without assigning the blame to any module?

Jon.


