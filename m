Return-Path: <linux-kernel-owner+w=401wt.eu-S1760965AbXEPLFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965AbXEPLFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXEPLFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:05:38 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:17532 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbXEPLFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:05:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=IooR3BT2oSmeHn3XcvGGucaKZH3LsLNHk0emIgrGXALLaD4IjNv0nQIJwwd9Y+h9540ZMIvK+VoZHcXAuTFvShsQX8S8lJLOYNdxueJmtDPsBI5jvPTxhcU+mOowjWD/mqfYp+hto+OyVd3aOgtj5BtD32Co0a+sRMIdJ9WFcVM=
Message-ID: <464AE56F.3040101@gmail.com>
Date: Wed, 16 May 2007 13:05:19 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org>
In-Reply-To: <20070515185350.2e77bf21.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Andrew Morton wrote:
> On Wed, 16 May 2007 09:24:54 +0900 Clemens Schwaighofer <cs@tequila.co.jp> wrote:
> 
>> I have re-occurring oopses and panics in those above kernels. The error
>> is always the same. I have the last Kernel Panic as a picture here:
>>
>> http://dev.tequila.jp/clemens/R0010172.JPG
>>
>> The oops have the same error style like this Panic. I tried to capture
>> one, but right after copying it into vim, I got a Panic. So next time I
>> try to.
>>
>> I think it started with 2.6.19.2, I cannot remember I had any of those
>> problems before. The box can work fine for about a week or more, or it
>> looks up several times a day. I run a memtest for 10 h, but I had no errors.
> 
> shrink_dcache_memory->...sysfs_d_iput->BUG
> 
>                 BUG_ON(sd->s_dentry != dentry);
> 
> a number of people have hit that, on and off.

Yeah, I've been seeing that one.  It should have been fixed with the big
fat patchset.

> We were close to having a fix, I think, but then we decided that great
> chunks of sysfs needed rewriting and I believe that we believe that this
> great rewrite will fix this bug.

How were we gonna fix it?  If it isn't too complex, I can cook up a
patch for -stable series.  The safest approach I can think of is making
dentries for attributes unreclaimable but those are made reclaimable for
good reasons.  :-(

Thanks.

-- 
tejun
