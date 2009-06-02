Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZFBX3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZFBX3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbZFBX3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:29:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58415 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826AbZFBX3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:29:40 -0400
Date: Wed, 3 Jun 2009 01:28:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Merge Xen (the hypervisor) into Linux
Message-ID: <20090602232843.GA6577@elte.hu>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <20090602224051.GB32428@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602224051.GB32428@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Now here's a crazy solution. Merge the Xen hypervisor into Linux 
> ;-)

That's not that crazy - it's the right technical solution if DOM0 is 
desired for upstream. From what i've seen in DOM0 land the incestous 
dependencies are really only long-term manageable if the whole thing 
is in a single tree.

A lot of Xen legacies could be dropped: the crazy ring1 hack on 
32-bit, the various wide interfaces to make pure-software 
virtualization limp along. All major CPUs shipped with hardware 
virtualization support in the past 2-3 years, so the availability of 
VMX and SVM can be taken for granted for such a project.

That cuts down on a fair amount of crap. A lot of code on the Linux 
side could be reused, and a pure CONFIG_PCI=y (all other things 
disabled) would provide a "slim hypervisor" instance with a very 
small and concentrated code base. (That 'slim hypervisor' might even 
be built with CONFIG_NOMMU.)

That way dom0 would be a natural extension: a minimal interface 
between Linux-Xen-minimal and the dom0 guest instance.

It's a sane technical model IMO, and makes dom0 a lot more 
palatable. Having in-tree competition to KVM would also obviously be 
good to Linux in general.

	Ingo
