Return-Path: <linux-kernel-owner+w=401wt.eu-S1762499AbYBGUtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762499AbYBGUtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:49:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYBGUtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:49:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:41300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbYBGUtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:49:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ZJ8E/dTq7GnEq7sZ9KniOMcVKIcyNVVZo+1WRt0uPWAo+PJeZVSr/d8Kl8oTAwI2h
	pv+A7b0IJVOoZs6DT+5RQ==
Message-ID: <6599ad830802071249g45cb2d6eybd00c1bef07cf5aa@mail.gmail.com>
Date: Thu, 7 Feb 2008 12:49:25 -0800
From: "Paul Menage" <menage@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH][DOCUMENTATION] Minimal controller code for a quick start
Cc: "Pavel Emelyanov" <xemul@openvz.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Containers" <containers@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1202416137.6274.42.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB25AD.30400@openvz.org> <1202416137.6274.42.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 12:28 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> While on the subject, could someone document struct cgroup_subsys.

There's documentation for all the methods in Documentation/cgroup.txt

> particular, I've wondered why we have: cgroup_subsys::can_attach() and
> not use a return value in cgroup_subsys::attach()?

We could do in theory do that, but it would make the recovery logic in
cgroup.c:attach_task() more complex - it would have to be able to deal
with undoing a partial attach. It seems simpler to just split it into
two phases, given that most cgroups don't appear to have attachment
conditions anyway.

Paul
