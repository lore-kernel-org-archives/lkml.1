Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbZCOSu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbZCOSu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbZCOSuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:50:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZCOSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:50:11 -0400
Message-ID: <49BD4CE1.6040100@zytor.com>
Date: Sun, 15 Mar 2009 11:45:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org> <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org>
In-Reply-To: <49BA7810.6090807@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jan Beulich wrote:
>> As pointed out on an earlier thread, it seems inappropriate to do probing
>> like this when there is a cpuid feature flag (osxsave) that can be
>> used to
>> determine whether XSAVE can be used. And even without that flag,
>> simply reading CR4 and checking whether osxsave is set there would
>> suffice. This is under the assumption that Xen's to-be-done
>> implementation
>> of XSAVE support would match that of FXSAVE (Xen turns its support on
>> unconditionally and for all [pv] guests).
> 
> I didn't want to make too many assumptions about how Xen's XSAVE support
> would look.  In particular, I thought it might virtualize the state of
> OSXSAVE to give the guest the honour of appearing to enable it.  A guest
> kernel may get confused if it starts with OSXSAVE set, as it may use it
> to control its own init logic.

That wouldn't be an issue if you use the *native* CPUID to look for
OSXSAVE early on, since such virtualization would only be visible though
the PV interface, right?

It seems cleaner than probing, to be sure...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

