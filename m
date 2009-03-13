Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbZCMKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbZCMKXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZCMKXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:23:08 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24513 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZCMKXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:23:07 -0400
Message-Id: <49BA3A84.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Fri, 13 Mar 2009 09:50:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
 <1236931920-6861-11-git-send-email-jeremy@goop.org>
In-Reply-To: <1236931920-6861-11-git-send-email-jeremy@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 13.03.09 09:11 >>>
>From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
>Xen leaves XSAVE set in cpuid, but doesn't allow cr4.OSXSAVE
>to be set.  This confuses the kernel and it ends up crashing on
>an xsetbv instruction.
>
>At boot time, try to set cr4.OSXSAVE, and mask XSAVE out of
>cpuid it we can't.  This will produce a spurious error from Xen,
>but allows us to support XSAVE if/when Xen does.

As pointed out on an earlier thread, it seems inappropriate to do probing
like this when there is a cpuid feature flag (osxsave) that can be used to
determine whether XSAVE can be used. And even without that flag,
simply reading CR4 and checking whether osxsave is set there would
suffice. This is under the assumption that Xen's to-be-done implementation
of XSAVE support would match that of FXSAVE (Xen turns its support on
unconditionally and for all [pv] guests).

Jan

