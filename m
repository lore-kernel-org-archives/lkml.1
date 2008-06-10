Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbYFJWay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbYFJWay (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760237AbYFJWaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:30:39 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41676 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760540AbYFJWab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:30:31 -0400
To: Jeff Garzik <jeff@garzik.org>
cc: Nicolas 2P <nicolas.2p.debian@free.fr>, David Miller <davem@davemloft.net>,
       bonding-devel@lists.sourceforge.net, linux-net@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch] bondig - arp_interval with low value => Oops.
In-reply-to: <484EFDFC.3040206@garzik.org>
References: <482C9E73.2040202@free.fr> <484EFDFC.3040206@garzik.org>
Comments: In-reply-to Jeff Garzik <jeff@garzik.org>
   message dated "Tue, 10 Jun 2008 18:19:40 -0400."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Tue, 10 Jun 2008 15:30:06 -0700
Message-ID: <8135.1213137006@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> wrote:

>Nicolas 2P wrote:
>> When setting arp_interval parameter to a very low value, delta_in_ticks
>> for next arp might become 0, causing an infinite loop.
>>
>> See http://bugzilla.kernel.org/show_bug.cgi?id=10680
>>
>> Same problem for miimon parameter already fixed, but fix might be
>> enhanced, by using msecs_to_jiffies() function.
>>
>> Signed-off-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>
>
>I don't see an ACK from Jay in my mbox?
>
>Certainly looks nicer than adding "? : 1" to each of the remaining two
>cases.

	This was accepted a couple of weeks ago; I had to fix a bug in
the patch, so I'd guess you didn't connect them:

commit 5ce0da8f0386b62345312ec8fed31303732f4220
Author: Jay Vosburgh <fubar@us.ibm.com>
Date:   Sat May 17 21:10:07 2008 -0700

    bonding: Use msecs_to_jiffies, eliminate panic
    
        Convert bonding to use msecs_to_jiffies instead of doing the
    math.  For the ARP monitor, there was an underflow problem that could
    result in an infinite loop.  The miimon already had that worked around,
    but this is cleaner.
    
        Originally by Nicolas de Pesloüan <nicolas.2p.debian@free.fr>
    Jay Vosburgh corrected a math error in the original; Nicolas' original
    commit message is:
    
    When setting arp_interval parameter to a very low value, delta_in_ticks
    for next arp might become 0, causing an infinite loop.
    
    See http://bugzilla.kernel.org/show_bug.cgi?id=10680
    
    Same problem for miimon parameter already fixed, but fix might be
    enhanced, by using msecs_to_jiffies() function.
    
    Signed-off-by: Nicolas de Pesloüan <nicolas.2p.debian@free.fr>
    Signed-off-by: Jay Vosburgh <fubar@us.ibm.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>


	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
