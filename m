Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbXKANtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbXKANtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXKANtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:49:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbXKANtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:49:41 -0400
Message-ID: <4729D995.3030905@redhat.com>
Date: Thu, 01 Nov 2007 11:50:13 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com, tglx@linutronix.de,
       jun.nakajima@intel.com, glommer@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 11/16] turn priviled operation into a macro in head_64.S
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com> <11938581562552-git-send-email-gcosta@redhat.com> <11938581612389-git-send-email-gcosta@redhat.com> <47295B2A.3080200@goop.org>
In-Reply-To: <47295B2A.3080200@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> under paravirt, read cr2 cannot be issued directly anymore.
>> So wrap it in a macro, defined to the operation itself in case
>> paravirt is off, but to something else if we have paravirt
>> in the game
>>   
> 
> Is this actually needed?  It's only used in the early fault handler in
> head_64.S.  Will we be taking that path in the paravirt case?  If so,
> should we disable the fault handler altogether, since the hypervisor can
> probably provide better diagnositcs.
> 

Well, as you told me earlier, xen won't use it. Neither does lguest.
None of us goes through the normal boot process anyway. But maybe some
other technology uses it?

Zach, how does it work for vmware?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHKdmVjYI8LaFUWXMRAgxkAKCQB+VtpGSlm+zuyRRWmi3h+k9NqQCgyfmD
cpPyQcfxo9hcSI0WaDFmpWg=
=Oa4v
-----END PGP SIGNATURE-----
