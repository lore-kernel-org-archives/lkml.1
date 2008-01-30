Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYA3Bsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYA3Bsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYA3BsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:48:24 -0500
Received: from c60.cesmail.net ([216.154.195.49]:59194 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbYA3BsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:48:23 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <1201652420.2271.91.camel@perihelion>
References: <1201641765.18773.35.camel@dv>
	 <1201652420.2271.91.camel@perihelion>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 20:48:21 -0500
Message-Id: <1201657701.24898.14.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 19:20 -0500, Jon Masters wrote:

> Yes it is. But I thought the existing code was intending to taint the
> kernel (that's what it does), so it would really help to identify why it
> tainted the kernel, by calling add_taint_module instead of add_taint. I
> didn't put the existing match in there...don't shoot the messenger :)

So, it's the same thing as in year 2006.  Good intentions, unexpected
side effects, and a long discussion.

> > - ndiswrapper needs GPL-only symbols
> 
> Another fix would be for ndiswrapper to explicitly set the taint when it
> loads a tainted driver? Or do we just want to go back to globally
> "tainting" the kernel without assigning the blame to any module?

It taints the kernel, but not the module.  I could add tainting the
module to the ndiswrapper code, but it would reply on the internals of
the "struct module".  And I think we really don't want modules tainting
and untainting themselves by changing THIS_MODULE->taints.  It's a
Pandora's box that's better kept closed.

-- 
Regards,
Pavel Roskin
