Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbXLDSVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbXLDSVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750996AbXLDSVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:21:15 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33694 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbXLDSVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:21:14 -0500
To: "Chris Friesen" <cfriesen@nortel.com>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       bonding-devel@lists.sourceforge.net
Subject: Re: when using arp monitoring with bonding, why use broadcast arps? 
In-reply-to: <47558DFC.5050601@nortel.com> 
References: <47558DFC.5050601@nortel.com>
Comments: In-reply-to "Chris Friesen" <cfriesen@nortel.com>
   message dated "Tue, 04 Dec 2007 11:27:24 -0600."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Tue, 04 Dec 2007 10:20:56 -0800
Message-ID: <17022.1196792456@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen <cfriesen@nortel.com> wrote:
[...]
>Is there any particular reason why the bonding code couldn't use unicast
>arp packets if the "arp_ip_target" has a valid entry in the sender's arp
>table?

	It ought to be a pretty straightforward change to have the
bond_arp_send() function perform a neigh_lookup() prior to calling
arp_create(), and use the result of the lookup (if any) in the
arp_create() call.

	So, no, with the caveat that I haven't tried it, I don't see a
reason that bonding couldn't do what you're looking for.

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
