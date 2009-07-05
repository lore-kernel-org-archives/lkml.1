Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZGEAWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZGEAWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 20:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZGEAWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 20:22:05 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35452 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZGEAWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 20:22:03 -0400
To: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi\@redhat.com" <avi@redhat.com>
References: <20090701133007.GC27539@redhat.com>
	<1246482017.27006.10670.camel@localhost.localdomain>
	<20090703082905.GF21833@elte.hu> <m1r5wwbxjx.fsf@fess.ebiederm.org>
	<20090704095556.GB24641@redhat.com> <m1r5wwa56k.fsf@fess.ebiederm.org>
	<20090704155002.GC24641@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 04 Jul 2009 17:22:01 -0700
In-Reply-To: <20090704155002.GC24641@redhat.com> (Gleb Natapov's message of "Sat\, 4 Jul 2009 18\:50\:02 +0300")
Message-ID: <m1prcgyo5y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gleb@redhat.com, avi@redhat.com, kvm@vger.kernel.org, sheng@linux.intel.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gleb Natapov <gleb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v5] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov <gleb@redhat.com> writes:

>> Therefore I don't see the point of supporting one without the other.
> x2apic provide us with other benefits as commit message explains, and
> doesn't add any problems that we don't have now already.

If this code has a legitimate place on real hardware I am all for it.

If this is just a hack to make virtualization faster I don't like the
extra code paths in the middle core architecture code.  That will
be a support burden for the foreseeable future.  More code to
test etc. 

Quickly skimming the patch it just appears to stir a mess.
Plus it adds weird paravirtualization checks, ???

If we are going to have a special code path for virtual hardware
can we do it right and have something nice to use that makes life
simpler?  For what we want to do with ioapics they suck and are
really not suitable.  The only thing that recommends them is that
they are standard.  But you are deviating from the standard so
what is the point.

Eric

