Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZCSVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZCSVTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754725AbZCSVTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:19:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:36415 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbZCSVTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:19:35 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, tglx@linutronix.de,
       xemul@openvz.org
References: <1236891719.32630.14.camel@bahia>
	<20090312212124.GA25019@us.ibm.com>
	<604427e00903122129y37ad791aq5fe7ef2552415da9@mail.gmail.com>
	<20090313053458.GA28833@us.ibm.com>
	<alpine.LFD.2.00.0903131018390.3940@localhost.localdomain>
	<20090313193500.GA2285@x200.localdomain>
	<alpine.LFD.2.00.0903131401070.3940@localhost.localdomain>
	<1236981097.30142.251.camel@nimitz> <49BADAE5.8070900@cs.columbia.edu>
	<m1hc1xrlt5.fsf@fess.ebiederm.org> <20090314081207.GA16436@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Mar 2009 14:19:15 -0700
In-Reply-To: <20090314081207.GA16436@elte.hu> (Ingo Molnar's message of "Sat\, 14 Mar 2009 09\:12\:07 +0100")
Message-ID: <m1hc1p9pnw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, xemul@openvz.org, tglx@linutronix.de, torvalds@linux-foundation.org, sukadev@linux.vnet.ibm.com, akpm@linux-foundation.org, mpm@selenic.com, viro@zeniv.linux.org.uk, linux-mm@kvack.org, adobriyan@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com, containers@lists.linux-foundation.org, linux-api@vger.kernel.org, dave@linux.vnet.ibm.com, orenl@cs.columbia.edu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ do?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> >> In the OpenVZ case, they've at least demonstrated that the 
>> >> filesystem can be moved largely with rsync.  Unlinked files 
>> >> need some in-kernel TLC (or /proc mangling) but it isn't 
>> >> *that* bad.
>> >
>> > And in the Zap we have successfully used a log-based 
>> > filesystem (specifically NILFS) to continuously snapshot the 
>> > file-system atomically with taking a checkpoint, so it can 
>> > easily branch off past checkpoints, including the file 
>> > system.
>> >
>> > And unlinked files can be (inefficiently) handled by saving 
>> > their full contents with the checkpoint image - it's not a 
>> > big toll on many apps (if you exclude Wine and UML...). At 
>> > least that's a start.
>> 
>> Oren we might want to do a proof of concept implementation 
>> like I did with network namespaces.  That is done in the 
>> community and goes far enough to show we don't have horribly 
>> nasty code.  The patches and individual changes don't need to 
>> be quite perfect but close enough that they can be considered 
>> for merging.
>> 
>> For the network namespace that seems to have made a big 
>> difference.
>> 
>> I'm afraid in our clean start we may have focused a little too 
>> much on merging something simple and not gone far enough on 
>> showing that things will work.
>> 
>> After I had that in the network namespace and we had a clear 
>> vision of the direction.  We started merging the individual 
>> patches and things went well.
>
> I'm curious: what is the actual end result other than good 
> looking code? In terms of tangible benefits to the everyday 
> Linux distro user. [This is not meant to be sarcastic, i'm
> truly curious.]

Of the network namespace?  Sorry I'm not certain what you are asking.

Eric
