Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbZJHOqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbZJHOqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 10:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758242AbZJHOqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 10:46:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206AbZJHOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 10:46:33 -0400
Message-ID: <4ACDFB1F.6040803@redhat.com>
Date: Thu, 08 Oct 2009 16:45:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB528D.6030408@gmail.com> <4ACB6F0E.4000407@redhat.com> <4ACB7794.5040308@gmail.com> <4ACB77C8.9060007@gmail.com> <4ACB9D24.2060105@gmail.com> <4ACC4D46.1090805@redhat.com> <4ACC8E19.8070706@gmail.com>
In-Reply-To: <4ACC8E19.8070706@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 02:48 PM, Gregory Haskins wrote:
>
>> If f() can cause another agent to write to p (by freeing
>> it to a global list, for example), then it is its responsibility to
>> issue the smp_rmb(), otherwise no calculation that took place before f()
>> and accessed p is safe.
>>
>>      
> IOW: David is right.  You need a cpu-barrier one way or the other.  We
> can either allow ->release() to imply one (and probably document it that
> way, like we did for slow-work), or we can be explicit.

No, ->release() must do it or it becomes impossible to program.  And in 
fact it will, to place the freed structure on a global list it must take 
a lock which implies an smp_rmb().

> I chose to be
> explicit since it is kind of self-documenting, and there is no need to
> be worried about performance since the release is slow-path.
>    

It's so self-documenting I had no idea what it was there for.

-- 
error compiling committee.c: too many arguments to function

