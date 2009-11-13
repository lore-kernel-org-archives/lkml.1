Return-Path: <linux-kernel-owner+w=401wt.eu-S932519AbZKMXZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbZKMXZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbZKMXZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:25:54 -0500
Received: from soto.provo.novell.com ([137.65.250.214]:48647 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932435AbZKMXZx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-pmullaney@novell.com;5:1>);
	Fri, 13 Nov 2009 18:25:53 -0500
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 18:25:53 EST
Message-Id: <4AFD83CF020000C700079883@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 13 Nov 2009 16:05:35 -0700
From: "Patrick Mullaney" <pmullaney@novell.com>
To: <shemminger@vyatta.com>
Cc: <arnd@arndb.de>, <bridge@lists.linux-foundation.org>,
       <alacrityvm-devel@lists.sourceforge.net>, <kaber@trash.net>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/3] macvlan: support for guest vm direct rx/tx
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 13:27 -0800, Stephen Hemminger wrote:
> On Fri, 13 Nov 2009 14:55:06 -0500
> Patrick Mullaney <pmullaney@novell.com> wrote:
> 
> > These patches allow other modules to override the receive
> > path of a macvlan. This is being done to support guest
> > VMs operating directly over a macvlan. Routines to allow
> > creation and deletion of macvlans from in-kernel modules
> > were also exposed/added.
> 
> Which guest VM, how will it use it? The kernel is not in the business
> of providing infrastructure for out of tree patches.

Actually, any guest vm or container. macvtap was the first to suggest
a patch like this to provide this functionality. This infrastructure
is generic enough to allow others to use it. My interest is in
supporting kvm guests via vbus drivers which are being integrated
in the alacrityvm tree.

> 
> Also, macvlan should really being calling netif_receive_skb()
> not going through another queue/softirq cycle.
I understand but you are talking about the current behavior of
macvlans - my goal wasn't to change the current behavior
of macvlans, as I didn't want to disturb what the original author
intended, just provide the ability to override the rx path and
provide for management of macvlans from other kernel modules(not
just via rtnl).


