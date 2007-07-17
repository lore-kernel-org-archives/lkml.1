Return-Path: <linux-kernel-owner+w=401wt.eu-S935128AbXGQR4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935128AbXGQR4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbXGQR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:56:05 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39741 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764274AbXGQR4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:56:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PKhQ/5E4c1M4bEALK3/wvWF3OBwrETINNsXIdRXAyDFSDq3vhikj2K2PCMgUeFuFB
	LSI62Kwqo9te/sWq0Gyxw==
Message-ID: <6599ad830707171055ua1e1135ief95a5ff3cf9dfc9@mail.gmail.com>
Date: Tue, 17 Jul 2007 10:55:52 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: Containers: css_put() dilemma
Cc: balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, xemul@sw.ru,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       akpm@linux-foundation.org
In-Reply-To: <20070717105341.9e51cc79.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
	 <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
	 <469C99D1.7090807@linux.vnet.ibm.com>
	 <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
	 <469CFF2B.1080702@linux.vnet.ibm.com>
	 <20070717105341.9e51cc79.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Paul Jackson <pj@sgi.com> wrote:
>
> At least for cpusets (the mother of all containers), notify on release
> is part of the user visible API of cpusets.  The kernel does not remove
> cpusets; it runs a user program, /sbin/cpuset_release_agent.  That
> program might choose to rmdir the cpuset directory, and/or do other
> actions, like notify a batch scheduler that one of its cpusets was
> released.

Right, that's what the release agent patch for process containers does
- there's a file in the hierarchy root called "release_agent" that
contains the path to the program to run if a notify_on_release
container goes idle. When you mount the "cpuset" filesystem, it
automatically populates that file with "/sbin/cpuset_release_agent". A
workqueue task is used to actually do the notifications so that
references can be dropped without having to potentially run a
userspace helper.

Paul
