Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbYIQTFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbYIQTFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 15:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbYIQTFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 15:05:23 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:58347 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYIQTFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 15:05:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dean Nelson <dcn@sgi.com>,
       Alan Mayer <ajm@sgi.com>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <Yinghai.lu@amd.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu>
	<48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
	<20080911152304.GA13655@sgi.com> <20080914153522.GJ29290@elte.hu>
	<20080915215053.GA11657@sgi.com> <20080916082448.GA17287@elte.hu>
	<20080916204654.GA3532@sgi.com> <20080917173032.GA5674@sgi.com>
Date: Wed, 17 Sep 2008 11:59:05 -0700
In-Reply-To: <20080917173032.GA5674@sgi.com> (Dimitri Sivanich's message of
	"Wed, 17 Sep 2008 12:30:32 -0500")
Message-ID: <m17i9a61l2.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Dimitri Sivanich <sivanich@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0005]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitri Sivanich <sivanich@sgi.com> writes:

> On Tue, Sep 16, 2008 at 03:46:54PM -0500, Dean Nelson wrote:
>> On Tue, Sep 16, 2008 at 10:24:48AM +0200, Ingo Molnar wrote:
>> > 
>> > * Dean Nelson <dcn@sgi.com> wrote:
>> > 
>> > > > while i understand the UV_BAU_MESSAGE case (TLB flushes are 
>> > > > special), why does sgi-gru and sgi-xp need to go that deep? They are 
>> > > > drivers, they should be able to make use of an ordinary irq just 
>> > > > like the other 2000 drivers we have do.
>> > > 
>> > > The sgi-gru driver needs to be able to allocate a single irq/vector 
>> > > pair for all CPUs even those that are not currently online. The sgi-xp 
>> > > driver has similar but not as stringent needs.

I need to look at these patches some more (apologies I got busy).

We can not assign a vector to all CPUS.

We don't have the fields for vector -> irq mapping for cpus that
are not-online.  So we can only assign to cpus that are online now.
And latter add the other cpus when they come online.

I have had that oops, it sucks, I don't want to go back.

Eric



