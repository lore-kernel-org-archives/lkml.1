Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbYCWBMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbYCWBMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 21:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbYCWBMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 21:12:39 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40164 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835AbYCWBMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 21:12:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
cc: Libor Pechacek <lpechacek@suse.cz>, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] bonding: Fix sysfs attribute handling 
In-reply-to: <20080322172704.49fa557b.akpm@linux-foundation.org> 
References: <200803211452.55982.lpechacek@suse.cz> <20080322172704.49fa557b.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Sat, 22 Mar 2008 17:27:04 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.1-RC4; GNU Emacs 22.0.95
Date: Sat, 22 Mar 2008 18:12:34 -0700
Message-ID: <18749.1206234754@death>
From: Jay Vosburgh <fubar@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

>On Fri, 21 Mar 2008 14:52:55 +0100 Libor Pechacek <lpechacek@suse.cz> wrote:
>
>> bonding: Fix sysfs attribute handling
>> 
>> For bonding interfaces any attempt to read the sysfs directory contents after
>> module removal results in an oops.  The fix is to release sysfs attributes
>> for the interfaces upon module unload.
>> 
>> Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
>> --
>>  drivers/net/bonding/bond_main.c |    3 +--
>>  1 files changed, 1 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index 0942d82..33767d4 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -4528,8 +4528,7 @@ static void bond_free_all(void)
>>  		netif_tx_unlock_bh(bond_dev);
>>  		/* Release the bonded slaves */
>>  		bond_release_all(bond_dev);
>> -		bond_deinit(bond_dev);
>> -		unregister_netdevice(bond_dev);
>> +		bond_destroy(bond);
>>  	}
>
>Is this also needed in 2.6.24.x?

	Yes (I haven't tested it personally, but the affected code is
the same).  I was going to forward this to stable when it was accepted
upstream.  The oops is fairly straightforward to create:

# modprobe bonding
# cd /sys/class/net/bond0/bonding
# rmmod bonding
# ls

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
