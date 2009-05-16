Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZEPE1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZEPE1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 00:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZEPE04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 00:26:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58828 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZEPE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 00:26:55 -0400
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
	<20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>
	<20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>
	<m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org>
	<20090515202250.0f1218ef@jbarnes-g45>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 15 May 2009 21:26:47 -0700
In-Reply-To: <20090515202250.0f1218ef@jbarnes-g45> (Jesse Barnes's message of "Fri\, 15 May 2009 20\:22\:50 -0700")
Message-ID: <m1iqk1k708.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: jbarnes@virtuousgeek.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, mingo@elte.hu, jeremy@goop.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jesse Barnes <jbarnes@virtuousgeek.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [GIT PULL] xen /proc/mtrr implementation
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Fri, 15 May 2009 16:49:12 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>> Eric W. Biederman wrote:
>> >> /proc/mtrr is in wide use today.  It may be planned for
>> >> obsolescence, but there's no way you can claim its obsolete today
>> >> (my completely up-to-date F10 X server is using it, for example).
>> >> We don't break oldish usermode ABIs in new kernels.
>> >>     
>> >
>> > Sure it is.  There is a better newer replacement.  It is taking a
>> > while to get userspace transitioned but that is different.
>> > Honestly I am puzzled why that it but whatever.
>> >   
>> 
>> There's no mention in feature-removal-schedule.txt.

I don't know that it makes sense to remove mtrrs but it certainly
doesn't make sense to use them if you can avoid it.

>> >> Besides, the MTRR code is also a kernel-internal API, used by DRM
>> >> and other drivers to configure the system MTRR state.  Those
>> >> drivers will either perform badly or outright fail if they can't
>> >> set the appropriate cachability properties. That is not obsolete
>> >> in any way. 
>> >
>> > There are about 5 of them so let's fix them.
>> >   
>> 
>> Well, I count at least 30+, but anyway.

Wow.  We had a lot of those slip in.  Definitely time to fix the
drivers.

>> > With PAT we are in a much better position both for portability and
>> > for flexibility.
>> >   
>> 
>> PAT is relatively recent, and even more recently bug-free.  There are 
>> many people with processors which can't or won't do PAT; what's the
>> plan to support them?  Just hit them with a performance regression?
>> Or wrap MTRR in some other API?

PPro is roughly when PAT came out.  I remember discussing this a while
ago and the conclusion was that there are very few systems with MTRRs
that don't have a usable PAT implementation.  I expect many of those
systems are on their last legs today.

>> Sure, when available.  We're sorting out the details for Xen, but
>> even then it may not be available, either because we're running on an
>> old version of Xen, or because some other guest is using PAT
>> differently.

There are only 3 states that are interesting.  WB UC and WC.  Since
Xen controls the page tables anyway.  I expect it can even remap
it feels like it.

>> But I honestly don't understand the hostility towards 120 lines of
>> code to make an interface (albeit legacy/deprecated/whatever) behave
>> in an expected way.

> FWIW I think supporting the MTRR API in Xen makes sense.  There's a lot
> of old code out there that wants it; would be nice if it mostly worked,
> especially at such a minimal cost.  It's taken awhile to get PAT going
> (and there are still issues here and there) so having the MTRR stuffa
> available is awfully nice.

I won't argue that having MTRRs when you can makes sense.  It is a bit
weird in a vitalized system.  At a practical level there are an
increasing number of systems for which MTRRs are unusable because the
BIOS sets up overlapping mtrrs.  With cheap entry level systems
shipping with 4G I expect it is becoming a majority of systems.

Eric
