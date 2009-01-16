Return-Path: <linux-kernel-owner+w=401wt.eu-S934897AbZAPNr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934897AbZAPNr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934075AbZAPNr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:47:28 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:40971 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364AbZAPNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:47:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=pnN1lioIGwGPmGgKR24L/cXM+F4SVfMtfQYbK9hhBUGZ6/dYVCBp/XWdwI+nSGzADq
         7Y3gGQ3uotgMHTiCgcKj1agS5lJp4DE4DGUQL+YpfgJCtWNvDhtvbbE43p3YoOYKJTWz
         9KTPbqw09/6vEsnK48veDNDf7iPWykHZy3qiE=
Message-ID: <49708FEA.9000508@gmail.com>
Date: Fri, 16 Jan 2009 22:47:22 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: roel kluin <roel.kluin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Brian Gerst <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
Subject: Re: [PATCH x86/percpu] x86_64: initialize this_cpu_off to	__per_cpu_load
References: <496F0F5E.3080404@kernel.org> <20090115113230.GH22850@elte.hu> <496F1FA6.6050204@kernel.org> <20090115122222.GI22850@elte.hu> <496F3577.4020303@kernel.org> <20090115133206.GA31416@elte.hu> <20090115133916.GA3417@elte.hu> <496FB09A.8020808@kernel.org> <496FE2B3.3060706@gmail.com> <496FFE45.1070802@gmail.com> <20090116131601.GA20593@elte.hu>
In-Reply-To: <20090116131601.GA20593@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> +#ifdef CONFIG_X86_64
>> +DEFINE_PER_CPU(unsigned long, this_cpu_off) = (unsigned long)__per_cpu_load;
>> +#else
>>  DEFINE_PER_CPU(unsigned long, this_cpu_off);
>> +#endif
> 
> I've pulled your tree, but couldnt we do this symmetrically in the 32-bit 
> case too and avoid the ugly #ifdef somehow?

You can take the "x86_32: make percpu symbols zerobased on SMP" patch
and the above ifdef won't be necessary along with similar one in
setup_percpu.c.  The above ifdef is because 64 is zero based while 32
is not.  If you want something, say, __per_cpu_base_off or something
to be defined conditionally and used in these two cases, I'm not sure
whether that would clean up the code or obfuscate it.  :-)

Thanks.

-- 
tejun
