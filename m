Return-Path: <linux-kernel-owner+w=401wt.eu-S1030400AbXDDEGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400AbXDDEGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992600AbXDDEFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:05:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992610AbXDDEFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:05:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OYE5DZjeiEDr5mF6eoE+9k6eb1yK2TF8CAxtEIjgn6LC5FHk4OZcqAlRuaemJAFzA
	CgyQkJNY0psJYOA+f8Tew==
Message-ID: <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
Date: Tue, 3 Apr 2007 21:04:59 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070404030756.GA9008@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070403153220.GA24946@sergelap.austin.ibm.com>
	 <20070403164615.GJ2456@in.ibm.com>
	 <6599ad830704030952r5c295f3ap6e366de31dab2ccb@mail.gmail.com>
	 <20070403171155.GK2456@in.ibm.com>
	 <6599ad830704031010i5418abf1o12b11334cde4d2c5@mail.gmail.com>
	 <20070403173048.GL2456@in.ibm.com>
	 <6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
	 <20070403175101.GN2456@in.ibm.com>
	 <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	 <20070404030756.GA9008@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> User space queries like "what is the cpuset to which this task belongs",
> where the answer needs to be something of the form "/dev/cpuset/C1"?
> The patches address that requirement atm by having a dentry pointer in
> struct cpuset itself.

Have you posted the cpuset implementation over your system yet?

The drawback to that is that every subsystem has to add a dentry to
its state, and handle the processing.

>
> Do you see similar queries coming in for every resource controller object
> (show me the path of cpu_acct, cpu_ctl, rss_ctl ... objects to which this
> task belongs)? IMO that will not be the case, in which case we can avoid
> adding N pointers (N = max hierarchies) in nsproxy just to support queries of
> those sort.

OK, I see your argument that putting it in the aggregator probably
isn't the best thing to do from a space point of view in the case when
the number of aggregators

This seems like a place where my container_subsys_state object is
useful - it can store a pointer to the container object (and be
maintained by the generic container system), at a space cost of 1
pointer per subsystem grouping, rather than N pointers per aggregator.

Paul
