Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIIWy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIIWy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYIIWyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 18:54:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:9563 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbYIIWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 18:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pvoas14qgMcQuGw+gD4HQiWU9YKFwYWa1MAJOwkBWvIOtSAovCcPq4XWzOtr2J+fc5
         fu3ai5qfyViRHwZjsdrqVOzHTi0tw5dxTI91MMvAkwFbDdFnR8f84ckvMpSdmWGiXA2A
         8LM8/kECS324CctwLPXpgpEox2+kpnJmFwwbo=
Message-ID: <86802c440809091554y349366fdu8e4ca59797ab4205@mail.gmail.com>
Date: Tue, 9 Sep 2008 15:54:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: TARGET_CPUS in assign_irq_vector
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48C6F913.1010509@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48C6F913.1010509@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2008 at 3:30 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> On x86-64, the genapic implementations of target_cpus returns
> cpu_online_map.  What if more cpus have yet to come online?  Shouldn't
> it be cpu_possible_map?
>
> Though I'm probably confused.  I don't really know what the intent of
> target_cpus and vector_allocation_domain is.
>
logical mode, vector_allocation_domain will return all online cpus aka
the 8 cpus.

phys_flat mode, vector_allotcation_domain will only the cpumask with
the cpu set..

target_cpus is the cpus that could be possible to used to take vector
and process that irq. so at least it should be online.

YH
