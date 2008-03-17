Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYCQRHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYCQRHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 13:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYCQRHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 13:07:01 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:64935 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYCQRHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 13:07:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JoiOibqJaGil530NmuHzWrc8qsNvVy+YKOVnvVl21/KSXv7gtPP4tZd1nFkoYnEjfGUi6rOWaol8++WboTl0UVSTsUAYprsYTxjf2ecpj4APa1fJMz3p8E0EASXaf7v2kboZcrdSE7gFKQjk4WKhSqbLdQ5OZuV4vghM6uVP9Fs=
Message-ID: <804dabb00803171006i4423c5b6w58bd95116510d3f5@mail.gmail.com>
Date: Tue, 18 Mar 2008 01:06:33 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: per cpun+ spin locks coexistence?
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>, "Tejun Heo" <htejun@gmail.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>
In-Reply-To: <87bq5e1kvm.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00803120917w451b16e6q685016d464a2edde@mail.gmail.com>
	 <47DABBCE.5010803@goop.org>
	 <804dabb00803160930t40b7c415ic38f2b9955b515ac@mail.gmail.com>
	 <87bq5e1kvm.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the explanation, much apologies for this newbie discussion.
  But I still find it inexplicable:

On Mon, Mar 17, 2008 at 4:20 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>
>  A per-cpu variable is basically an array the size of the number of
>  possible CPUs in the system.  get_cpu_var() checks what current CPU we
>  are running on and gets the array-element corresponding to this CPU.
>
>  So, really oversimplified, get_cpu_var(foo) translates to something like
>  foo[smp_processor_id()].
>

Ok, so calling get_cpu_var() always return the array-element for the
current CPU, and since by design, only the current CPU can
modify/write to this array element (this is my assumption - correct?),
and the other CPU will just read it (using the per_cpu construct).
So far correct?   So why do u still need to spin_lock() to lock other
CPU from accessing - the other CPU will always just READ it, so just
go ahead and let them read it.   Seemed like it defeats the purpose of
get_cpu_var()'s design?

But supposed u really want to put a spin_lock(), just to be sure
nobody is even reading it, or modifying it, so then what is the
original purpose of get_cpu_var() - is it not to implement something
that can be parallelized among different CPU, without affecting each
other, and using no locks?

The dual use of spin_lock+get_cpu_var() confuses me here :-).   (not
the per_cpu(), which I agree is supposed to be callabe from all the
different CPU, for purpose of enumeration or data collection).

-- 
Regards,
Peter Teoh
