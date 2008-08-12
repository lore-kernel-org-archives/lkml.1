Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbYHLVAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbYHLVAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHLVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:00:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21120 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYHLVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:00:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DvqT2Gi3aOoyXBllbTcY4JLNA17PJnXhMKnhcp2eeZpi8kYw+aU4JlFne2OxWvUk/C
         lq9k+pVVwAYCLfQSWzKrRIK/4eRHu+b74Z5KVo7c7z+kCnnIsFLHE88XAcrrrbkNj1Pr
         eUsXJKMy9sYP5fNr+HXVFybl+1T0H0tV2bZbI=
Message-ID: <48A1F9EE.5080602@gmail.com>
Date: Tue, 12 Aug 2008 23:00:30 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: James.Smart@Emulex.Com
CC: fernando@oss.ntt.co.jp, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, taka@valinux.co.jp,
       dm-devel@redhat.com, agk@sourceware.org, baramsori72@gmail.com,
       dave@linux.vnet.ibm.com, ngupta@google.com, balbir@linux.vnet.ibm.com
Subject: Re: RFC: I/O bandwidth controller
References: <1218117578.11703.81.camel@sebastian.kern.oss.ntt.co.jp><48A0A689.40908@gmail.com>	<loom.20080812T071504-212@post.gmane.org><20080812.201025.57762305.taka@valinux.co.jp><48A18854.9020000@gmail.com> <48A18B1F.6080000@gmail.com> <1218549276.4456.100.camel@sebastian.kern.oss.ntt.co.jp> <D1D4C3FF75F9354393DB8314DF43DEF2E7F7ED@xbl3.emulex.com>
In-Reply-To: <D1D4C3FF75F9354393DB8314DF43DEF2E7F7ED@xbl3.emulex.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James.Smart@Emulex.Com wrote:
> Fernando Luis Vázquez Cao wrote:
>>> BTW as I said in a previous email, an interesting path to 
>> be explored
>>> IMHO could be to think in terms of IO time. So, look at the 
>> time an IO
>>> request is issued to the drive, look at the time the 
>> request is served,
>>> evaluate the difference and charge the consumed IO time to the
>>> appropriate cgroup. Then dispatch IO requests in function of the
>>> consumed IO time debts / credits, using for example a token-bucket
>>> strategy. And probably the best place to implement the IO time
>>> accounting is the elevator.
>> Please note that the seek time for a specific IO request is strongly
>> correlated with the IO requests that preceded it, which means that the
>> owner of that request is not the only one to blame if it 
>> takes too long
>> to process it. In other words, with the algorithm you propose 
>> we may end
>> up charging the wrong guy.
> 
> I assume all of these discussions are focused on simple storage - disks
> direct attached to a single server - and are not targeted at SANs with
> arrays, multi-initiator accesses, and fabric/network impacts. True ? 
> Such algorithms can be seriously off-base in these latter configurations.

Accounting the IO cost using time values should be in principle a
topology-agnostic solution, so it should work both for LUs from SAN,
magnetic disks, USB drive, optical drives, etc. because we're actually
looking at the time spent to execute each IO operation (and you don't
need to know the details of the particular IO operation, because you
automatically know the actual cost).

If you mean that trying to evaluate or even predict the cost of the seek
ops is so meaningful in those "complex" environments, well.. yes, in
this case I agree.

-Andrea
