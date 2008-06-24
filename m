Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbYFXX0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbYFXX0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYFXX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:26:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYFXX03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:26:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=LzYVySVrGO2vcNZCCrqcm6t0w3iJ9GTvlsTZB79mTOptPs5qSt58H6GRsq1NWiVtN
	HjidK2BEZOTgdqEGMNrVg==
Message-ID: <6599ad830806241626q51933106v7de4a2445d3a45fe@mail.gmail.com>
Date: Tue, 24 Jun 2008 16:26:21 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/8] CGroup Files: Add write_string cgroup control file method
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080624161923.449ecea4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080620234358.182933000@menage.corp.google.com>
	 <20080621000730.052131000@menage.corp.google.com>
	 <20080624161923.449ecea4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 4:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>>       /*
>> +      * write_string() is passed a nul-terminated kernelspace
>> +      * buffer of maximum length determined by max_write_len.
>> +      * Returns 0 or -ve error code.
>> +      */
>> +     int (*write_string)(struct cgroup *cgrp, struct cftype *cft,
>> +                         const char *buffer);
>
> Everything seems to use size_t (or ssize_t?) except for the ->write_string
> return value.  Can any of this be improved?

What other things are you including as "everything"?

write_string() returns 0 on success or a -ve error code on failure -
it doesn't have the concept of writing some fraction of the passed
bytes.

The functions that deal in size_t/ssize_t (along with userspace
buffers, files and position pointers) are the glue that interfaces
with the filesystem layer. My aim (which is furthered by this patch
series) is to keep as much of that as possible in the cgroup layer
itself, and to reduce filesystem glue in the cgroup subsystems. The
raw file interface is still exposed by cgroups for those subsystems
that really need it, but it should be the exception rather than the
rule.

Paul
