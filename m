Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXKML1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXKML1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbXKML1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:27:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbXKML1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:27:40 -0500
Message-ID: <47398A68.8080009@redhat.com>
Date: Tue, 13 Nov 2007 09:28:40 -0200
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070811)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: [PATCH 2/3] kvmclock - the host part.
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <4736D6C0.8040408@qumranet.com>
In-Reply-To: <4736D6C0.8040408@qumranet.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Avi Kivity escreveu:
> Glauber de Oliveira Costa wrote:
>> This is the host part of kvm clocksource implementation. As it does
>> not include clockevents, it is a fairly simple implementation. We
>> only have to register a per-vcpu area, and start writting to it
>> periodically.
>>
>>   
> 
> Missing live migration support  (a way for userspace to read and write
> the guest clock address).  Should probably be in a separate patch.

I think it's a matter of issuing a hypercall for reading the clock
address. It's fair simple, and can be done in a later version of this patch.
As for writting, the register hypercall itself can be used. It has no
special side-effects we should care about.

>> @@ -1924,6 +1955,7 @@ out:
>>          goto preempted;
>>      }
>>  
>> +    kvm_write_guest_time(vcpu);
>>      post_kvm_run_save(vcpu, kvm_run);
>>   
> 
> Why here?  Seems like we're leaving the guest for a while at this place.
> 
> Suggest putting it on top of __vcpu_run(), guarded by a flag, and
> setting the flag every time we put the vcpu.

No special preference. It just sounded exity enough to me. I can move to
where you suggest.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Remi - http://enigmail.mozdev.org

iD8DBQFHOYpojYI8LaFUWXMRApf8AJ4jQ/ZTBlub1IwFkJrYZyart+f7bwCfT+9m
l1Rblsmw96ZatCf60g2dNYY=
=DBpn
-----END PGP SIGNATURE-----
