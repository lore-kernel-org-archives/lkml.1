Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXCVAFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXCVAFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964981AbXCVAFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:05:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:12633 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbXCVAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:04:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=U5hqDFbcwfSU4saxLkwVlAuDp24b5Y2gajwHu3tEeVPhz+YdzuxRLtZtlKW1lOV+Vp3KOKjBWPt9VT5Q5WKb7sIvYkhBZSDwQLjsm647InUhVaQ3TfGQkARojADjUaPT7FyUZGj5qfgZhfaSVhoGOlvhUzDC7bta4QuvKO/QWgs=
From: Maxim <maximlevitsky@gmail.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [RFC] : Is /proc/kcore still usefull and/or maintained ?
Date: Thu, 22 Mar 2007 02:04:50 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Andi Kleen <ak@suse.de>,
       David Howells <dhowells@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200703211840.53242.maximlevitsky@gmail.com> <200703220128.18610.maximlevitsky@gmail.com> <20070322005310.03be8637.dada1@cosmosbay.com>
In-Reply-To: <20070322005310.03be8637.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220204.51146.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 01:53:10 Eric Dumazet wrote:
> I stand corrected : This is a new bug
> 
> The /proc/kcore problem appears with linux-2.6.21-rc4-mm1
> 
> fd = open("/proc/kcore", 0);
> llseek(fd, ...) returns an -EINVAL error
> 
> 
> Quick code inspection (before going to sleep...) shows that
> 
> proc_reg_llseek() (file fs/proc/inode.c)
> 
> is doing something like :
> 
> rv = -EINVAL;
> llseek = pde->proc_fops->llseek;
> spin_unlock(&pde->pde_unload_lock);
> if (llseek)
> 	rv = llseek(file, offset, whence);
> 
> As kcore dont have a .llseek handler, proc_reg_llseek() returns -EINVAL;
> 
> Previous kernel was probably calling a default llseek() handler.
> 
> if (!llseek)
> 	llseek = default_llseek;
> 
> Hum ???
> 

Hi,
	Yes, you are right, you have different problem that I had

	But why do you need llseek ?

	Why not to mmap it ?
	It is natural thing to do with files that represent memory.

	Regards,
		Maxim Levitsky
