Return-Path: <linux-kernel-owner+w=401wt.eu-S932900AbXGQRmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900AbXGQRmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbXGQRmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:42:25 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:60448 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367AbXGQRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:42:24 -0400
Message-ID: <469CFF2B.1080702@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2007 23:10:59 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: =?windows-1252?Q?=22Paul_=28=3F=3F=29_Menage=22?= 
	<menage@google.com>
CC: dhaval@linux.vnet.ibm.com, Pavel Emelianov <xemul@sw.ru>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Jackson <pj@sgi.com>, Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Containers: css_put() dilemma
References: <469BBE00.8000709@linux.vnet.ibm.com> <6599ad830707161203o7f148c75p52e77d4be3ace487@mail.gmail.com> <469C2792.6050009@linux.vnet.ibm.com> <6599ad830707161935n69776f1t98292fc9990f4766@mail.gmail.com> <20070717070031.GA22410@linux.vnet.ibm.com> <6599ad830707170018p180cb7dfr53e609fd0b186e30@mail.gmail.com> <469C99D1.7090807@linux.vnet.ibm.com> <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
In-Reply-To: <6599ad830707170849v11fe8cecs6d172cd38d247e09@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul (??) Menage wrote:
> Because as soon as you do the atomic_dec_and_test() on css->refcnt and
> the refcnt hits zero, then theoretically someone other thread (that
> already holds container_mutex) could check that the refcount is zero
> and free the container structure.
> 

Hi, Paul,

That sounds correct. I wonder now if the solution should be some form
of delegation for deletion of unreferenced containers (HINT: work queue
or kernel threads).

> Adding a synchronize_rcu in container_diput() guarantees that the
> container structure won't be freed while someone may still be
> accessing it.
> 

Do we take rcu_read_lock() in css_put() path or use call_rcu() to
free the container?

>>
>> Could you please elaborate as to why using a release agent is broken
>> when the memory controller is attached to it?
> 
> Because then it will try to take container_mutex in css_put() if it
> drops the last reference to a container, which is the thing that you
> said you had to avoid since you called css_put() in contexts that
> couldn't sleep.
> 
> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
