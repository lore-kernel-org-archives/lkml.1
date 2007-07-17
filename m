Return-Path: <linux-kernel-owner+w=401wt.eu-S1765656AbXGQHSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765656AbXGQHSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758865AbXGQHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:18:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37347 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189AbXGQHSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:18:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=kmc6WidxMfRWPx6usTiFGCk5hOCCpLWBmC0NMbgAmSXElNfGoKQ0/LAILX/zN66X3
	63bHCXLRkPUEjZSMeaUjA==
Message-ID: <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com>
Date: Tue, 17 Jul 2007 00:18:33 -0700
From: "=?ISO-2022-JP?B?UGF1bCAoGyRCSnVOXBsoQikgTWVuYWdl?=" 
	<menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Containers: css_put() dilemma
Cc: "Pavel Emelianov" <xemul@sw.ru>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Paul Jackson" <pj@sgi.com>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, dhaval@linux.vnet.ibm.com
In-Reply-To: <20070717070031.GA22410@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BBE00.8000709@linux.vnet.ibm.com>
	 <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com>
	 <469C2792.6050009@linux.vnet.ibm.com>
	 <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com>
	 <20070717070031.GA22410@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >
> > >                mutex_lock(&container_mutex);
> > >                set_bit(CONT_RELEASABLE, &cont->flags);
> > >-               if (atomic_dec_and_test(&css->refcnt)) {
> > >-                       check_for_release(cont);
> > >-               }
> > >+               check_for_release(cont);
> > >                mutex_unlock(&container_mutex);
> > >

I think that this isn't safe as it stands, without a synchronize_rcu()
in container_diput() prior to the kfree(). Also, it will break if
anyone tries to use a release agent on a hierarchy that has your
memory controller bound to it.

Paul
