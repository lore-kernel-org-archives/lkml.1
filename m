Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXDCRK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXDCRK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXDCRK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:10:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26814 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663AbXDCRK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:10:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cblzRXY3+scBtJFzDWeR90RaPmgVOih5XbZ5J7NBFU67xjpMjo3/UidKN119VFiT+
	yAX/WnRWx40IoZ8Fax9xw==
Message-ID: <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
Date: Tue, 3 Apr 2007 10:10:35 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, devel@openvz.org
In-Reply-To: <20070403171155.GK2456@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070331024722.GA808@in.ibm.com>
	 <20070402140938.GF17710@sergelap.austin.ibm.com>
	 <20070402142727.GF2456@in.ibm.com>
	 <m1slbiejt0.fsf@ebiederm.dsl.xmission.com>
	 <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <6599ad830704030845p654cf8dh65ccdc46c92d3688@mail.gmail.com>
	 <20070403164615.GJ2456@in.ibm.com>
	 <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	 <20070403171155.GK2456@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Tue, Apr 03, 2007 at 09:52:35AM -0700, Paul Menage wrote:
> > I'm not saying "let's use nsproxy" - I'm not yet convinced that the
> > lifetime/mutation/correlation rate of a pointer in an nsproxy is
> > likely to be the same as for a container subsystem; if not, then
> > reusing nsproxy could actually increase space overheads (since you'd
> > end up with more, larger nsproxy objects, compared to smaller numbers
> > of smaller nsproxy objects and smaller numbers of smaller
> > container_group objects), even though it saved (just) one pointer per
> > task_struct.
>
> Even if nsproxy objects are made larger a bit, the number of such object will

You're not making them "a bit" larger, you're adding N+M pointers
where N is the number of container hierarchies and M is the number of
subsystem slots.

Basically, it means that anyone that uses containers without
namespaces or vice versa ends up paying the space overheads for both.

> be -much- lesser compared to number of task_structs I would think, so
> the win/lose in space savings would need to take that into account.

Agreed. So I'm not saying it's fundamentally a bad idea - just that
merging container_group and nsproxy is a fairly simple space
optimization that could easily be done later.

Paul
