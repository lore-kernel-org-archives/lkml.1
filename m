Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXDCQwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXDCQwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbXDCQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:52:54 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25938 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXDCQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:52:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LgJvRaenfULrxqNKdDvp3KEZVXjYTIFLUElGa2yfAcNB3TXCPUGN0yr8Ql6jAnGLB
	M8hppxz7bNlxZ1/BOp28g==
Message-ID: <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
Date: Tue, 3 Apr 2007 09:52:35 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, devel@openvz.org
In-Reply-To: <20070403164615.GJ2456@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085105.170265000@menage.corp.google.com>
	 <20070331024722.GA808@in.ibm.com>
	 <20070402140938.GF17710@sergelap.austin.ibm.com>
	 <20070402142727.GF2456@in.ibm.com>
	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	 <20070403164615.GJ2456@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Tue, Apr 03, 2007 at 08:45:37AM -0700, Paul Menage wrote:
> > Whilst I've got no objection in general to using nsproxy rather than
> > the container_group object that I introduced in my latest patches,
>
> So are you saying lets (re-)use tsk->nsproxy but also retain 'struct
> container' to store general per-group state? If so, I think that would
> address my main concern of redundant/avoidable new pointers in
> task_struct introduced in the container patches ..

I'm not saying "let's use nsproxy" - I'm not yet convinced that the
lifetime/mutation/correlation rate of a pointer in an nsproxy is
likely to be the same as for a container subsystem; if not, then
reusing nsproxy could actually increase space overheads (since you'd
end up with more, larger nsproxy objects, compared to smaller numbers
of smaller nsproxy objects and smaller numbers of smaller
container_group objects), even though it saved (just) one pointer per
task_struct.

Reusing nsproxy versus using a separate container_group object as the
aggregator is mostly an implementation detail, i think, and it would
be pretty easy to switch from one to the other without any
user-visible changes. So I'm inclined to keep them separate at this
point.

Paul
