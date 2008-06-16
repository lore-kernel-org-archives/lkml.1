Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbYFPU5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbYFPU5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbYFPU5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:57:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43564 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYFPU5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:57:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:in-reply-to:references:mime-version:content-type:
	message-id:cc:content-transfer-encoding:from:subject:date:to:x-mailer;
	b=rSvM8haF3//gwtDBBY2Ea2O4on5HOAm92QDHGtei7cw8zTVrm6fEgOZr9YiAqQq6r
	02CdSIWrVVfysB+XYHP7g==
In-Reply-To: <75b07c02-1595-4af2-ac87-3b067459f62e@w8g2000prd.googlegroups.com>
References: <20030410181011$6d15@gated-at.bofh.it> <aC1Yl-2AL-1@gated-at.bofh.it> <75b07c02-1595-4af2-ac87-3b067459f62e@w8g2000prd.googlegroups.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <48D0786A-AC3B-46C3-B35C-EAAA47BFAEBC@google.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, matt@bluehost.com,
       roberto@unbit.it, randy.dunlap@oracle.com, akpm@linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Divyesh Shah <dpshah@google.com>
Subject: Re: i/o bandwidth controller infrastructure
Date: Mon, 16 Jun 2008 13:51:34 -0700
To: Andrea Righi <righi.andrea@gmail.com>, balbir@linux.vnet.ibm.com,
       menage@google.com
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> This is the core io-throttle kernel infrastructure. It creates the
> basic
> interfaces to cgroups and implements the I/O measurement and
> throttling
> functions.

I am not sure if throttling an application's cpu usage by explicitly  
putting it to sleep
in order to restrain it from making more IO requests is the way to go  
here (though I can't think
of anything better right now).
With this bandwidth controller, a cpu-intensive job which otherwise  
does not care about its IO
performance needs to be pin-point accurate about IO bandwidth  
required in order to not suffer
from cpu-throttling. IMHO, if a cgroup is exceeding its limit for a  
given resource, the throttling
should be done _only_ for that resource.

-Divyesh
