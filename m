Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbYEMVqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbYEMVqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757901AbYEMVqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:46:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5878 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYEMVqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:46:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=joAIdl0zZi4X4dWn7SzUCOTH53jqG5/oVqQ6D5IY4UqYhcF2GIa1Z6qw//AeqUqG3
	cmvfXRSWjX5jNu80myrmQ==
Message-ID: <6599ad830805131446w11dadd4ag69db715e81513b3d@mail.gmail.com>
Date: Tue, 13 May 2008 14:46:05 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 1/8]: CGroup Files: Add locking mode to cgroups control files
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080513143206.ef259829.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.133586000@menage.corp.google.com>
	 <20080513130127.fcd46a41.akpm@linux-foundation.org>
	 <6599ad830805131417m4f8cc2e6iac42c0fb089a8cb1@mail.gmail.com>
	 <20080513143206.ef259829.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 2:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>  But do we ever expect that cgroup_mutex will be taken with much
>  frequency, or held for much time?  If it's only taken during, say,
>  configuration of a group or during a query of that configuration then
>  perhaps we'll be OK.

I'm not so worried about contention on the userspace configuration
side - more the case of configuration operations stalling
subsystem-initiated operations. An example of that would be the case
of hierarchical reclaim in the memory controller, where it needs to be
able to traverse up and down the hierarchy without the hierarchy
changing under its feet.

I'll dump the implicit lock_mode support and make it more explicit in
the subsystem handlers.

Paul
