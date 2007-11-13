Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbXKMLhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbXKMLhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbXKMLhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:37:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbXKMLhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:37:07 -0500
Message-ID: <47398C4A.40806@redhat.com>
Date: Tue, 13 Nov 2007 09:36:42 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Steven Rostedt <rostedt@goodmis.org>,
       kiran@scalemp.com
Subject: Re: [PATCH 24/24] make vsmp a paravirt client
References: <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com> <11946338832681-git-send-email-gcosta@redhat.com> <1194633888761-git-send-email-gco!sta@redhat.com> <11946338932611-git-send-email-gcosta@redhat.com> <1194633898545-git-send-email-gcosta@redhat.com> <11946339033567-git-send-email-gcosta@redhat.com> <11946339082711-git-send-email-gcosta@redhat.com> <11946339142999-git-send-email-gcosta@redhat.com> <20071111180709.GG22277@bingen.suse.de>
In-Reply-To: <20071111180709.GG22277@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Andi Kleen escreveu:
> On Fri, Nov 09, 2007 at 04:43:05PM -0200, Glauber de Oliveira Costa wrote:
>> This patch makes vsmp a paravirt client. It now uses the whole
>> infrastructure provided by pvops. When we detect we're running
>> a vsmp box, we change the irq-related paravirt operations (and so,
>> it have to happen quite early), and the patching function
> 
> The PARAVIRT ifdefs look wrong. Surely you don't need them at all
> because it cannot work at all without paravirt.

The vsmp_64.c file is now compiled unconditionally, according to which
me and kiran agreed to. The detection code is always run, but will only
trigger when a suitable box is found. Accordingly, the paravirt structs
are only touched when PARAVIRT is on. Otherwise, we don't even have the
symbols.

> Also you got some white space damage.

Thanks, will fix.

> And the "EM64T based comment" is wrong because there are AMD based 
> vSMPs too.
Just got it as-is from the old Kconfig. Do you think it should be fixed
as well?

> -Andi

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHOYxKjYI8LaFUWXMRApS3AJwJSYjW4Lw3dnPR4yMNfXABnMoQQQCcDMnf
3wBQoPjGO/8HO1Os4Y21vIU=
=S+KO
-----END PGP SIGNATURE-----
