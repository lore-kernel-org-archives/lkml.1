Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbZFEHyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbZFEHyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755188AbZFEHyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:54:20 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:52795 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563AbZFEHyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NN8QYTe6XwFLKWpCakxOXA5rxsUhpnZ42hcEwQKn1eEOD2xlaNnpTtuEsS0n0isNAi
         eCgrpEk3D2XbxAb2kelFpqmpVQN2ga+sN01Tge5XCmvs+mGvPsMHwMNIxxl7tvd+RzVM
         JKieeIERjZMtuFhs6dd10NmF20uqAijbxNkbg=
Date: Fri, 5 Jun 2009 15:56:14 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64
	2.6.30-rc8.
Message-ID: <20090605075614.GC8171@cr0.nay.redhat.com>
References: <4A289928.7040508@oracle.com> <20090604223805.2962e826.akpm@linux-foundation.org> <4A28C262.5020605@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A28C262.5020605@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 02:59:46PM +0800, Tao Ma wrote:
>
>
> Andrew Morton wrote:
>> On Fri, 05 Jun 2009 12:03:52 +0800 Tao Ma <tao.ma@oracle.com> wrote:
>>
>>> Hi list,
>>>        In 2.6.30-rc8, /proc/kcore in x86_64's size is unreasonable 
>>> large to be 281474974617600.
>>> While in a x86 box, it is 931131392 which looks sane.
>>>
>>> [root@test8 ~]# ll /proc/kcore
>>> -r-------- 1 root root 281474974617600 Jun  5 11:15 /proc/kcore
>>>
>>> [root@ocfs2-test9 ~]$ ll /proc/kcore
>>> -r-------- 1 root root 931131392 Jun  5 11:58 /proc/kcore
>>>
>>> I just noticed this when kexec fails in "Can't find kernel text map 
>>> area from kcore".
>>>
>>> Is there something wrong?
>>>
>>
>> fs/proc/kcore.c hasn't changed since October last year.  Was 2.6.29 OK?
>> Earlier kernels?
> with 2.6.29, ls shows the same output.
> [root@test8 ~]# ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun  5 14:35 /proc/kcore


Thanks.

It looks like the value of 'high_memory' is insane.. 

Can you get its value on your machine? You can add a printk() or use
systemtap etc..
