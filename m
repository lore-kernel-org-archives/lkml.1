Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXDEBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXDEBhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 21:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDEBhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 21:37:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:18929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXDEBhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 21:37:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oPWc/ZEjeuBh12/R2bFtg5RsuKEuc1TM1gsJOz/IupvxN57OQ05ZOJNvvoMTDTn1m
	ZaImRnResPAbmh2VW3ndw==
Message-ID: <6599ad830704041837h3583108bkf8e7d9ded23e916@mail.gmail.com>
Date: Wed, 4 Apr 2007 18:37:23 -0700
From: "Paul Menage" <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       dev@sw.ru, devel@openvz.org
In-Reply-To: <6599ad830704041835g38d40e8auc79ed8436bec19bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070403171155.GK2456@in.ibm.com>
	 <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	 <20070404030756.GA9008@in.ibm.com>
	 <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
	 <20070404051526.GA16562@in.ibm.com>
	 <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com>
	 <20070404172643.GA28328@in.ibm.com>
	 <6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com>
	 <m1ircb2168.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830704041835g38d40e8auc79ed8436bec19bb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/4/07, Paul Menage <menage@google.com> wrote:
> The current code creates such arrays when it needs an atomic snapshot
> of the set of tasks in the container (e.g. for reporting them to
> userspace or updating the mempolicies of all the tasks in the case of
> cpusets). It may be possible to do it by traversing tasklist and
> dropping the lock to operate on each task where necessary - I'll take
> a look at that.

Just to clarify this - the cases that currently need an array of task
pointers *do* already traverse tasklist in order to locate those tasks
as needed - its when they want to be able to operate on those tasks
outside of the tasklist lock that the array is needed - lock
tasklist_lock, fill the array with tasks (with added refcounts), drop
tasklist_lock, do stuff.

Paul
