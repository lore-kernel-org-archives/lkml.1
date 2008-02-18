Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYBRJlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYBRJlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYBRJlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:41:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:11971 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYBRJlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:41:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=uWlos2atQAGWSqPxBrAq99VL9lPpy3NHPeHvI6MwUWReEWo9ecWjOQrYJsYYroWxXbyO0ZiEB2B+e/WQDP3ZduB9U6aZ3c/Tl7Wn93YU9HFgy3FDb3JsrSKdHC8tDV12o56i71QF6AOFH659HeU/9qmv6cDlexxPLDmNpA0cWb8=
Message-ID: <47B952D3.2030900@gmail.com>
Date: Mon, 18 Feb 2008 11:41:39 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>, xfs@oss.sgi.com,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
References: <47B863A9.5070206@gmail.com> <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com> <20080217224736.GX155407@sgi.com>
In-Reply-To: <20080217224736.GX155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> On Sun, Feb 17, 2008 at 05:51:08PM +0100, Oliver Pinter wrote:
>   
>> On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
>>     
>>> Hi,
>>>
>>> xfsaild is causing many wakeups, a quick investigation shows
>>> xfsaild_push is always
>>> returning 30 msecs timeout value.
>>>       
>
> That's a bug

Ok. Your patches fixes the 30+ wakeups :)

> , and has nothing to do with power consumption. ;)
>   

I suggest using a sysctl value (such as
/proc/sys/vm/dirty_writeback_centisecs), instead of a hardcoded default
1000.
That would further reduce the wakeups.

>
> I only managed to reproduce this on a lazy superblock counter
> filesystem (i.e.  new mkfs and recent kernel), 

The filesystem was created in July 2007

> Can you see if the patch below fixes the problem.

Yes, it reduces wakeups to 1/sec.

Thanks,
--Edwin
