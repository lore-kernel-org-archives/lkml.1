Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZCNJvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZCNJvB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 05:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZCNJut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 05:50:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40377 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZCNJus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 05:50:48 -0400
Date: Sat, 14 Mar 2009 10:49:11 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work
	properly in bridge
Message-ID: <20090314094911.GA3455@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090313223932.50ebbd88@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313223932.50ebbd88@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sat, Mar 14, 2009 at 06:39:32AM CET, shemminger@linux-foundation.org wrote:
>On Fri, 13 Mar 2009 19:33:04 +0100
>Jiri Pirko <jpirko@redhat.com> wrote:
>
>> Hi all.
>> 
>> This is only a draft of patch to consult. I'm aware that it should be divided
>> into multiple patches. I want to know opinion from you folks.
>> 
>> The problem is described in following bugzilla:
>> https://bugzilla.redhat.com/show_bug.cgi?id=487763
>> 
>> Basically here's what's going on. In every mode, bonding interface uses the same
>> mac address for all enslaved devices. Except for mode balance-alb. When you put
>> this kind of bond device into a bridge it will only add one of mac adresses into
>> a hash list of mac addresses, say X. This mac address is marked as local. But
>> this bonding interface also has mac address Y. Now then packet arrives with
>> destination address Y, this address is not marked as local and the packed looks
>> like it needs to be forwarded. This packet is then lost which is wrong.
>> 
>> Notice that interfaces can be added and removed from bond while it is in bridge.
>> Therefore I introduce another function pointer in struct net_device_ops -
>> ndo_check_mac_address. This function when it's implemented should check passed
>> mac address against the one set in device. I'm using this in bonding driver when
>> the bond is in mode balance-alb to walk thru all slaves and checking if any of
>> them equals passed address.
>> 
>> Then in bridge function br_handle_frame_finish() I'm using ndo_check_mac_address
>> to recognize the destination mac address as local.
>> 
>> Please look at this and tell me what you think about it.
>> 
>> Thanks
>> 
>> Jirka
>>
>
>A better and more general way to do this have the dev_set_mac_address
>function check the return of the notifier and unwind. Then any protocol
>can easily prevent address from changing.

Can you please describe this thougth a bit more? I can't understand it now...

Thanks

Jirka
