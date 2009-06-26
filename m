Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbZFZTmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbZFZTmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZFZTl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:41:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58412 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbZFZTl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:41:58 -0400
To: "Pan\, Jacob jun" <jacob.jun.pan@intel.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Jun 2009 12:41:57 -0700
In-Reply-To: <43F901BD926A4E43B106BF17856F07556412B7E8@orsmsx508.amr.corp.intel.com> (Jacob jun Pan's message of "Thu\, 25 Jun 2009 17\:15\:20 -0700")
Message-ID: <m1ab3ubx4q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jacob.jun.pan@intel.com, hpa@linux.intel.com, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Pan\, Jacob jun" <jacob.jun.pan@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 9/9] x86/apic: support moorestown interrupt subsystem
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Pan, Jacob jun" <jacob.jun.pan@intel.com> writes:

>>From 82d64ca4f963d2e205326534aff0c77d9bfa5858 Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Fri, 12 Jun 2009 02:16:05 -0700
> Subject: [PATCH] x86/apic: support moorestown interrupt subsystem
>
> This patch uses platform flags to selectively enable apic related setup
> code.
>
> Since moorestown does not have legacy timer or PIC, the only system
> timer irqs are routed via ioapic. Early timer ioapic enabling is also
> added to allow boot time timing services.

This patch is horribly wrong.   We should not have a moorestown specific
hack  we should not do early timer ioapic on everything that supports
it which is most x86 machines since apics became common.

At which point moorestown support should just be a little work somewhere
in the table parsers.

If you can't compile out the 8259 support code this has been factored
wrong. 

There are a handful of legacy systems with mptables that run in ioapic
mode yet use the timer and sometimes a couple of other devices on
the 8259 PIC.  Handling that case will complicate things a bit.

Hopefully it will be easier now to properly rework the code.  When
I tried it.  Linus's laptop died somewhere half way through bootup.
So we had to revert the support.

In summary if moorestown does not have an 8259 PIC it is time to remove
this long standing deficiency of the x86 ioapic code, not hack around
it.

Eric
