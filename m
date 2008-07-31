Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYGaRKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYGaRKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYGaRJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 13:09:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:17805 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYGaRJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:09:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=QypBCToJUzqboC4l7M75ajDY/ZgTbt3LIDay9Z9F/LsoO535/DeXRPUgiQSY+i4qP
	zO0xIk+b89/U30QrsKDoQ==
Message-ID: <6599ad830807311009o4275c0d0k84d4a5d4eadc3f41@mail.gmail.com>
Date: Thu, 31 Jul 2008 10:09:42 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] Removes extra checking in kernel/cpuset.c
Cc: "Rakib Mullick" <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080731111522.6417f750.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10807310846g27913d82icf2a82e77992ba9f@mail.gmail.com>
	 <20080731111522.6417f750.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 9:15 AM, Paul Jackson <pj@sgi.com> wrote:
> Rakib wrote:
>> Hello guys, this patch removes an extra checking over 'cs' in
>> functions 'guarantee_online_cpus' and 'guarantee_online_mems'.
>> ...
>> -     while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
>> -             cs = cs->parent;
>> -     if (cs)
>> +     if (cs) {
>> +             while (!cpus_intersects(cs->cpus_allowed, cpu_online_map))
>> +                     cs = cs->parent;
>
> I don't think that works - "cs->parent" can be NULL, and will be NULL
> if cs is the root cpuset.

True, but if top_cpuset.cpus_allowed doesn't intersect with
cpu_online_map then maybe we have other problems?

Paul
