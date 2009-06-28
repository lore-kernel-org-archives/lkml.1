Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbZF1WGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbZF1WGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 18:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbZF1WG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 18:06:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43160 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZF1WG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 18:06:27 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	<20090625163050.d6a71a13.akpm@linux-foundation.org>
	<20090626104804.GA7337@hmsreliant.think-freely.org>
	<20090626092001.32e35e17.akpm@linux-foundation.org>
	<20090628193112.GA6760@one.firstfloor.org>
	<20090628135235.10f9b153.akpm@linux-foundation.org>
	<m163egt524.fsf@fess.ebiederm.org>
	<20090628214855.GC6760@one.firstfloor.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 15:06:25 -0700
In-Reply-To: <20090628214855.GC6760@one.firstfloor.org> (Andi Kleen's message of "Sun\, 28 Jun 2009 23\:48\:55 +0200")
Message-ID: <m1hby0qahq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: andi@firstfloor.org, alan@lxorguk.ukuu.org.uk, oleg@redhat.com, earl_chew@agilent.com, linux-kernel@vger.kernel.org, nhorman@tuxdriver.com, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andi Kleen <andi@firstfloor.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

>> Andrew should I toss all 100 or so patches over the wall to you
>> and your -mm tree?  Or should I maintain a public git tree based
>> at 2.6.31-rc1?  Get it into linux-next and ask Linus to pull it when
>> the merge window comes?
>
> What do these 100 odd patches do exactly? 

Mostly a fine grained killing of ctl_name, and strategy.

> I think DEFINE_SYSCTL()/ELF section would be the correct direction to go
> for all global variable sysctls.

Perhaps.  I don't know how those data structures interact with
what we have in kernel and in modules.

> Then the binary sysctls could be handled by a global table
> in a separate file like you described

Getting the binary sysctl crud out of the core path should
happen first.  That is just a handful of patches.

> For dynamically generated sysctls (relatively rare but there) 
> the current interfaces are not great, but could be probably kept.

Things like register_sysctl_path can be greatly improved.  Now
that we don't have to worry about the binary paths.

> That all doesn't really need 100 patches though.

If you want the patches to be small enough to be human readable it
takes a lot.  If you want the patches to be CC'able to the appropriate
maintainers and you don't want to require them to weed through a bunch of
irrelevant code it takes a lot.

Typos are a real danger in an operation like this.

Eric
