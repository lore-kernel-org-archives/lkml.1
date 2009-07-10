Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZGJUaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZGJUaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGJU3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:29:52 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49299 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZGJU3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:29:51 -0400
To: suresh.b.siddha@intel.com
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
       "garyhade\@us.ibm.com" <garyhade@us.ibm.com>
References: <20090629132926.GB20289@redhat.com>
	<m1ocs6axca.fsf@fess.ebiederm.org> <20090630092623.GI20289@redhat.com>
	<m1eit1acxl.fsf@fess.ebiederm.org> <4A4A476C.2070305@redhat.com>
	<m1ljn94k16.fsf@fess.ebiederm.org> <4A4A6499.9000406@redhat.com>
	<m1k52t1plq.fsf@fess.ebiederm.org>
	<1246488808.27006.10691.camel@localhost.localdomain>
	<m1d48kndje.fsf@fess.ebiederm.org>
	<1246983280.27006.10707.camel@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 10 Jul 2009 13:29:46 -0700
In-Reply-To: <1246983280.27006.10707.camel@localhost.localdomain> (Suresh Siddha's message of "Tue\, 07 Jul 2009 09\:14\:40 -0700")
Message-ID: <m1d488th6t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: suresh.b.siddha@intel.com, garyhade@us.ibm.com, kvm@vger.kernel.org, sheng@linux.intel.com, linux-kernel@vger.kernel.org, gleb@redhat.com, avi@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;suresh.b.siddha@intel.com
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v3] enable x2APIC without interrupt remapping under KVM
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha <suresh.b.siddha@intel.com> writes:

> On Wed, 2009-07-01 at 17:17 -0700, Eric W. Biederman wrote:
>> Suresh Siddha <suresh.b.siddha@intel.com> writes:
>> > Among number of experiments you have tried in the past to fix this, have
>> > you tried the experiment of explicitly clearing the remoteIRR by
>> > changing the trigger mode to edge and then back to level.
>> >
>> > Is there a problem with this?
>> 
>> The problem I had wasn't remoteIRR getting stuck, but the symptoms
>> were largely the same.  I did try changing the trigger mode to edge
>> and back and that did not unstick the ioapic in all cases.
>> 
>
> I did some experiments locally here yesterday and on my old ICH5 based
> system, I couldn't reset the remoteIRR by changing the trigger mode to
> edge and then back to level.
>
> However what worked was an explicit eoi to the io-apic using the
> respective vector.
>
> I guess we need to try both the things based on perhaps io-apic version
> etc.

In part the deep problems I ran into was something other than RemoteIRR.
If it was something as simple as the ioapic being in a documented state
I would have kept looking.  At the very least the RemoteIRR bit was not
set in some of the cases I encountered.

> But what I am nervous about is, did you try both these things aswell and
> still saw stuck interrupts?

Yes.  The work arounds were in the code so I tried them.

> I will cleanup my code and post it, so that we can try on different
> systems. If this still doesn't work on certain HW platforms, atleast our
> experiments of what works and what doesn't work and on what platforms
> will be documented on the web.

Sounds reasonable.  My apologies for the long delayed reply.  I want
to work on this but I have higher priorities.

Eric

