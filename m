Return-Path: <linux-kernel-owner+w=401wt.eu-S1765490AbXGQS0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765490AbXGQS0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 14:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXGQS0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:26:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28091 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729AbXGQS0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:26:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YeYEPB+Galdm9AplPnKhouCFyWmQb4dJx2pWyeBEaLLB5Rl7z5qiBmd3qYu9a4IF6
	pNHSL2Zf/oVIvOq3LwNdg==
Message-ID: <6599ad830707171126o7c431277p84f532d0122a8a98@mail.gmail.com>
Date: Tue, 17 Jul 2007 11:26:03 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Containers: css_put() dilemma
Cc: dhaval@linux.vnet.ibm.com, "Pavel Emelianov" <xemul@sw.ru>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <469D066B.6050606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
	 <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <469CFF2B.1080702@linux.vnet.ibm.com>
	 <6599ad830707171044u38c0a940r12d2bc80b475ead4@mail.gmail.com>
	 <469D066B.6050606@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> without too much knowledge of each other. BTW, what are the semantics
> of css_put() is it expected to free the container/run the release agent
> when the reference count of the container_subsys_state drops to zero?
>

If you css_put() the last reference on a subsystem state object and
the associated container is marked as notify_on_release, then
check_for_release() is called which does a more full check of whether
the container is releasable. If it is, a workqueue task is scheduled
to run the userspace release agent, which can then do anything it
wants, including potentially deleting the empty container.

Paul
