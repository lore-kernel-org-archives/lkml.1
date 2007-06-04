Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbXFDU4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbXFDU4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbXFDU40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:56:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419AbXFDU4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:56:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qWaz5/QjMeEsZ8e9QNM+H6Os654ESjzsFBWYakEkC0bm5l28FOsVgVty5hPUXHjyU
	BkKTdHApLKj1N+qS0OJcQ==
Message-ID: <6599ad830706041356r5a031dd5w2eeb3ff4c7c64b72@mail.gmail.com>
Date: Mon, 4 Jun 2007 13:56:12 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
In-Reply-To: <20070604205106.GA31530@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529130104.461765000@menage.corp.google.com>
	 <20070604191412.GA901@sergelap.austin.ibm.com>
	 <6599ad830706041332o718acb60ve0b5e38c2ca82c62@mail.gmail.com>
	 <20070604205106.GA31530@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/4/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> root@linuz11 root]# rm -rf /containers/1

Just use "rmdir /containers/1" here.

>
> Ah, I see the second time I typed 'ls /containers/1/tasks' instead of
> cat.  When I then used cat, the file was empty, and I got an oops just
> like Pavel reported.  I bet if I solve the problem he reported, then I
> solve my problem  :)
>

As far as I could see, Pavel's problem wasn't actually an Oops, it was
a WARN_ON() when allocating a zero length chunk of memory. There's
ongoing discussion as to whether this counts as a problem with the
allocators or the kmalloc() code, since it used to be OK to allocate a
zero-length chunk.

Paul
