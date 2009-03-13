Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZCMPNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZCMPNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbZCMPNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:13:24 -0400
Received: from gw.goop.org ([64.81.55.164]:58363 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbZCMPNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:13:24 -0400
Message-ID: <49BA7810.6090807@goop.org>
Date: Fri, 13 Mar 2009 08:13:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org> <49BA3A84.76E4.0078.0@novell.com>
In-Reply-To: <49BA3A84.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> As pointed out on an earlier thread, it seems inappropriate to do probing
> like this when there is a cpuid feature flag (osxsave) that can be used to
> determine whether XSAVE can be used. And even without that flag,
> simply reading CR4 and checking whether osxsave is set there would
> suffice. This is under the assumption that Xen's to-be-done implementation
> of XSAVE support would match that of FXSAVE (Xen turns its support on
> unconditionally and for all [pv] guests).

I didn't want to make too many assumptions about how Xen's XSAVE support 
would look.  In particular, I thought it might virtualize the state of 
OSXSAVE to give the guest the honour of appearing to enable it.  A guest 
kernel may get confused if it starts with OSXSAVE set, as it may use it 
to control its own init logic.

    J
