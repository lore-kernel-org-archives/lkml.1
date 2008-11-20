Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYKTBqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYKTBqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 20:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbYKTBpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 20:45:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:44169 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbYKTBpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 20:45:50 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, David Miller <davem@davemloft.net>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       adobriyan@gmail.com, Patrick McHardy <kaber@trash.net>, den@openvz.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>
References: <492489D1.5080502@gmail.com>
Date: Wed, 19 Nov 2008 17:37:35 -0800
In-Reply-To: <492489D1.5080502@gmail.com> (Michael Kerrisk's message of "Wed,
	19 Nov 2008 16:49:05 -0500")
Message-ID: <m1d4grfa8w.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michael Kerrisk <mtk.manpages@googlemail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: Current state of Network Namespaces (NETNS, CLONE_NEWNET)?
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Kerrisk <mtk.manpages@googlemail.com> writes:

> Sorry for the shotgun mail, but in the end,  it's
> not clear who can best answer my question(s).
>
> I'm currently trying to add documentation of all of
> the undocumented CLONE_* flags.  One of these is
> CLONE_NEWNET, and I could use (quite a lot of) help.  
>
> My questions:
>
> What is the current state of the network namespace 
> implementation?  Is it complete?  

No.  It is fairly close though and there is general agreement
on what it is.

ipv4 and ipv6 are mostly complete and useable.
ip tables support is in progress.
sysfs support is in progress.

decnet and other protocols are possible but there is not currently
any active work in that direction.

> What objects are considered part of the network 
> namespace, and therefore distinct for a new network 
> namespace?

A network namespace is to user space a new logical
instance of the kernel networking stack.

The full kernel networking stack is available in the
initial network namespace.  A subset of the kernel
networking stack is available in other network namespaces
depending upon how much code has been converted.

Network devices live in exactly one network namespace.

> Is there any documentation for network namespaces 
> already?

Not much.  Nor should it need much unique documentation.

Currently the truly unique command is:
ip link set <netdev> netns <pid>

Which moves a network device from one network namespace to another.

There are the veth pair network devices.
Designed so you can put one end in one network namespace and another
end in another network namespace.

There is the macvlan driver that can be sued to create multiple mac addresses
for your ethernet devices allowing native speed inside of a network namespace
on a machine with only one NIC.

There is the fact that /proc/net is now network namespace unique
There is the interesting games we play with /proc/sys/ so we have per network
namespace sysctls.

Other unique network namespace work under discussion.
- Unix domain sockets across network namespaces.
  Is doable but we haven't considered all of the technical details.
- The ongoing discussion about how we provide a more managable interface
  to network namespaces for people doing the whole linux-vrf thing.

Eric

