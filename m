Return-Path: <linux-kernel-owner+w=401wt.eu-S1761663AbYEMV1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761663AbYEMV1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757562AbYEMV1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:27:33 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3257 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbYEMV1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:27:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=qDZcJwSkvJGzgwoOIYGCLSfX7HYKCt7Ipz0enb/9RdfkG56TEwOPRsY+HGeiWhKEr
	x87CwLDnJwfMQ6OAFZJAA==
Message-ID: <6599ad830805131427t6ea1fdf3g6772225bb781b0c5@mail.gmail.com>
Date: Tue, 13 May 2008 14:27:24 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 6/8]: CGroup Files: Remove cpuset_common_file_write()
Cc: pj@sgi.com, xemul@openvz.org, balbir@in.ibm.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <20080513131134.8b1cefe2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080513063707.049448000@menage.corp.google.com>
	 <20080513071522.984545000@menage.corp.google.com>
	 <20080513131134.8b1cefe2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 1:11 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 12 May 2008 23:37:13 -0700
>  menage@google.com wrote:
>
>  > @@ -1412,14 +1355,18 @@ static struct cftype files[] = {
>  >       {
>  >               .name = "cpus",
>  >               .read = cpuset_common_file_read,
>  > -             .write = cpuset_common_file_write,
>  > +             .write_string = update_cpumask,
>  > +             .max_write_len = (100U + 6 * NR_CPUS),
>
>  hm, magic handwavy surely-enough-for-anyone constants.

This is just a movement of the check previously in cpuset_common_file_write():

	/* Crude upper limit on largest legitimate cpulist user might write. */
	if (nbytes > 100U + 6 * max(NR_CPUS, MAX_NUMNODES))
		return -E2BIG;

I'll add more comments. But I think it's a reasonable limit - assuming
that you wastefully enumerate each cpu individually, separated by
commas, 6 * NR_CPUS is enough for 100K CPUs.

Paul
