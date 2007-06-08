Return-Path: <linux-kernel-owner+w=401wt.eu-S1031271AbXFHSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031271AbXFHSOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970197AbXFHSOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:14:12 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8312 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970232AbXFHSOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:14:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=J6W7wtujhDV67cXxWixpkvwDgs7bSReuThdlPh1aqZHf4bL11gUwBQ+veQC61sDvr
	nCYPjtk7Pw7JaWzvo53hg==
Message-ID: <6599ad830706081113g56e755c6vc5cd0fbd5c15697@mail.gmail.com>
Date: Fri, 8 Jun 2007 11:13:41 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Paul Jackson" <pj@sgi.com>,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070608180837.GA5683@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070607000559.GA19529@sergelap.austin.ibm.com>
	 <20070607180158.GA936@sergelap.austin.ibm.com>
	 <20070607122121.24fe6ff4.pj@sgi.com>
	 <20070607201723.GA17011@sergelap.austin.ibm.com>
	 <20070607150113.f020d8f8.pj@sgi.com>
	 <20070608143250.GA7728@vino.hallyn.com>
	 <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com>
	 <20070608160840.GA11133@vino.hallyn.com>
	 <6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com>
	 <20070608180837.GA5683@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
> I do fear that that could become a maintenance nightmare.  For instance
> right now there's the call to fsnotify_mkdir().  Other such hooks might
> be placed at vfs_mkdir, which we'd then likely want to have placed in
> our container_mkdir() and container_clone() fns.  And of course
> may_create() is static inline in fs/namei.c.  It's trivial, but still if
> it changes we'd want to change the version in kernel/container.c as
> well.

Do we need to actually need to respect may_create() in
container_clone()? I guess it would provide a way for root to control
which processes could unshare namespaces.

>
> What would be the main advantage of doing it this way?  Do you consider
> the extra subys->auto_setup() hook to be avoidable bloat?
>

I was thinking that it would be nice to be able to atomically set up
the resources in the new container at the point when it's created
rather than later. But I guess this way can work too. Can we call it
something like "clone()" rather than "auto_setup()"?

Paul
