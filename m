Return-Path: <linux-kernel-owner+w=401wt.eu-S1763990AbXGFVKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763990AbXGFVKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763346AbXGFVKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:10:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:36594 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763013AbXGFVKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:10:12 -0400
Subject: Re: [-mm PATCH 1/8] Memory controller resource counters (v2)
From: Dave Hansen <haveblue@us.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <468EAE3E.4050802@linux.vnet.ibm.com>
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop>
	 <20070706052043.11677.56208.sendpatchset@balbir-laptop>
	 <1183742642.10287.151.camel@localhost>
	 <468EAE3E.4050802@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 14:10:05 -0700
Message-Id: <1183756205.10287.212.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 14:03 -0700, Balbir Singh wrote:
> 
> >> +ssize_t res_counter_read(struct res_counter *cnt, int member,
> >> +            const char __user *userbuf, size_t nbytes, loff_t
> *pos)
> >> +{
> >> +    unsigned long *val;
> >> +    char buf[64], *s;
> >> +
> >> +    s = buf;
> >> +    val = res_counter_member(cnt, member);
> >> +    s += sprintf(s, "%lu\n", *val);
> >> +    return simple_read_from_buffer((void __user *)userbuf, nbytes,
> >> +                    pos, buf, s - buf);
> >> +}
> > 
> > Why do we need that cast?  
> > 
> 
> u mean the __user? If I remember correctly it's a attribute for
> sparse.

The userbuf is already __user.  This just appears to be making a 'const
char *' into a 'void *'.  I wondered what the reason for that part is.

-- Dave

