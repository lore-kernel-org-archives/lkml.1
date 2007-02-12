Return-Path: <linux-kernel-owner+w=401wt.eu-S965306AbXBLSuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306AbXBLSuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965304AbXBLSuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:50:14 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50503 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965302AbXBLSuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:50:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=cgmo/HVXUI0qYtrzNy4SdO58YqwtPLr0DAD5GfRyA3D/h/0n/64usWi0shGLje0yW
	b0LhtOC/QvuJXCP55jUpw==
Message-ID: <6599ad830702121049l6055ab2asa6c42ac2c4afd61f@mail.gmail.com>
Date: Mon, 12 Feb 2007 10:49:58 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 6/7] containers (V7): BeanCounters over generic process containers
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
In-Reply-To: <20070212153410.GE7526@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <20070212085104.998727000@menage.corp.google.com>
	 <20070212153410.GE7526@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
> On Mon, Feb 12, 2007 at 12:15:27AM -0800, menage@google.com wrote:
> > This patch implements the BeanCounter resource control abstraction
> > over generic process containers.
>
> Forgive my confusion, but do we really need two-levels of resource control
> abstraction here? Why can't resource controllers directly work with containers
> (just like cpu accounting does)?
>

The generic containers patch represents a pretty low-level view of
task grouping - it doesn't try to prescribe how to do accounting, nor
exactly what API to present to the user (beyond providing a
filesystem-based interface).

Resource controllers certainly can be written directly over it, but
equally having additional abstractions to provide a common user API
and kernel API for multiple resources is a reasonable goal.

I would imagine that each different resource being controlled would be
represented as a container subsystem, which is how I structured the
ResGroups example patch - ResGroups becomes a library that provides a
common set of file manipulations for different resource controllers,
each of which is a containers subsystem. The same could potentially be
done for BeanCounters if people wanted.

But the main point of the latter four patches in this series is to
illustrate to the various folks writing resource controller systems
(and other observers) that this patch provides sufficient features to
act as a base for their work. I don't presume to claim that one
higher-level resource control abstraction is better than another.

Paul
