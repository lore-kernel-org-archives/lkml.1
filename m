Return-Path: <linux-kernel-owner+w=401wt.eu-S1030886AbXDJPp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030886AbXDJPp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 11:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030888AbXDJPp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 11:45:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40682 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030886AbXDJPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 11:45:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Lea4gkSxQfLw5pVtOY6NEIt+BiFaimHIV/WfNCUs5Khf5TpfIIX3nKadXCmd3Hkos
	GhwL1YpCvhaewE3p/CW0w==
Message-ID: <6599ad830704100845o23d8fb1dn17450ed48c51ad95@mail.gmail.com>
Date: Tue, 10 Apr 2007 08:45:13 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       containers@lists.osdl.org, serue@us.ibm.com, akpm@linux-foundation.org,
       devel@openvz.org
In-Reply-To: <20070410145220.GB3611@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <20070407001324.271959000@menage.corp.google.com>
	 <20070410145220.GB3611@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> Is the first argument into all the callbacks, struct container_subsys *ss,
> necessary?

I added it to support library-like abstractions - where one subsystem
can have its container callbacks and file accesses all handled by a
library which converts to a higher-level abstraction. See the
res_group example patch to see how it can be used.

>
> > +struct container_subsys cpuset_subsys = {
> > +     .name = "cpuset",
> > +     .create = cpuset_create,
> > +     .destroy  = cpuset_destroy,
> > +     .can_attach = cpuset_can_attach,
> > +     .attach = cpuset_attach,
> > +     .populate = cpuset_populate,
> > +     .subsys_id = cpuset_subsys_id,
> > +     .early_init = 1,
> > +};
>
> We seem to be missing a register call here as well ..

Registration is done at compile time in the new patch set, thanks to
the static declaration of subsystems and subsystem ids.
