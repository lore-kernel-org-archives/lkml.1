Return-Path: <linux-kernel-owner+w=401wt.eu-S1762791AbZEHQ7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762791AbZEHQ7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762549AbZEHQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:58:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762352AbZEHQ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:58:49 -0400
Message-ID: <4A0463D1.9090800@zytor.com>
Date: Fri, 08 May 2009 09:54:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com
Subject: Re: [PATCH 01/14] x86, boot: align the .bss section in the decompressor
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-2-git-send-email-hpa@linux.intel.com> <20090508071759.GA12808@uranus.ravnborg.org>
In-Reply-To: <20090508071759.GA12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>  	}
>> +	. = ALIGN(32);
> 
> Where does this magic 32 comes from?
> I would assume the better choice would be:
> 	. = ALIGN(L1_CACHE_BYTES);
> 
> So we match the relevant CPU.
> 
> In general for alignmnet of output sections I see the need for:
> 1) Function call
> 2) L1_CACHE_BYTES
> 3) PAGE_SIZE
> 4) 2*PAGE_SIZE
> 
> But I see magic constant used here and there that does not match
> the above (when looking at all archs).
> So I act when I see a new 'magic' number..
> 

I picked 32 as being larger than the maximum known size that affects rep
performance, but L1_CACHE_BYTES really would make more sense, you're right.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

