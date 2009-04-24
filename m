Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZDXT1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZDXT1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZDXT1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:27:06 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5073 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbZDXT1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:27:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=cJtLi0j8lmxwvLg/Irl41YkSBo4YhjfKFiY8SQxg+eVXioLi+kGRmo0HDG79AHLG1
	rm89hQSwh229ZKCm2nnIw==
Date: Fri, 24 Apr 2009 12:26:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zeno Davatz <zdavatz@gmail.com>
cc: linux-kernel@vger.kernel.org, Hannes Wyss <hwyss@ywesee.com>
Subject: Re: Kernel 2.6.29 runs out of memory and hangs.
In-Reply-To: <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904241224001.28589@chino.kir.corp.google.com>
References: <40a4ed590904240309o66753264lf58f2910726f7efc@mail.gmail.com> <alpine.DEB.2.00.0904241011280.24151@chino.kir.corp.google.com> <40a4ed590904241113p4949a020y46e0641e77f6f4e3@mail.gmail.com> <alpine.DEB.2.00.0904241155550.26080@chino.kir.corp.google.com>
 <40a4ed590904241216u655300ddvaa4660e11ad2cffc@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-861210070-1240601219=:28589"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-861210070-1240601219=:28589
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 24 Apr 2009, Zeno Davatz wrote:

> > These types of livelocks are possible with the oom killer when a task
> > fails to exit, one possible way to fix that is to introduce an oom killer
> > timeout such that if a task fails to exit for a pre-defined period of
> > time, the oom killer will choose to kill another task in the hopes of
> > future memory freeing.  The problem with that approach, however, is that
> > the hung task can consume an enormous amount of memory that will never be
> > freed.
> 
> Thanks for the hint! Is there another solution as well? Any
> Kernel-Upgrades in the Pipeline? What does Linus think about this?
> 

I had a patchset that added a timeout for oom killed tasks now that the 
entire oom killer is serialized, but it only really works well if your 
memory is so partitioned (such as with cpusets or the memory controller) 
that it actually makes sense to continue.  With global system-wide ooms 
such as yours, it would only result in a long chain of kills with no 
positive outcome.
--497827084-861210070-1240601219=:28589--
