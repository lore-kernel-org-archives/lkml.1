Return-Path: <linux-kernel-owner+w=401wt.eu-S1752254AbZG0PuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254AbZG0PuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG0Pt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:49:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:19717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZG0Pt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:49:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=lSy7Us0EmisJBL+6zUUc1MSf3ZQulJBZ2EKm2k8eQ0AoVr/3YnRaZb5SP0EYt5j7Q
	h4jbsK1msy+Gpl2HUfPqQ==
MIME-Version: 1.0
In-Reply-To: <4A6D37A4.6020605@cn.fujitsu.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032150.2463.49019.stgit@hastromil.mtv.corp.google.com>
	 <4A6D37A4.6020605@cn.fujitsu.com>
Date: Mon, 27 Jul 2009 11:49:39 -0400
Message-ID: <2f86c2480907270849x65af933fnc58d3cb243649b1f@mail.gmail.com>
Subject: Re: [PATCH 3/6] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Benjamin Blum <bblum@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 1:14 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Ben Blum wrote:
>> Quick vmalloc vs kmalloc fix to the case where array size is too large
>>
>> Separates all pidlist allocation requests to a separate function that judges
>> based on the requested size whether or not the array needs to be vmalloced or
>> can be gotten via kmalloc, and similar for kfree/vfree. Should be replaced
>> entirely with a kernel-wide solution to this general problem.
>>
>> Depends on cgroup-pidlist-namespace.patch, cgroup-procs.patch
>>
>> Signed-off-by: Ben Blum <bblum@google.com>
>>
>
> We'll either use flex_array or implement Paul's proposal, so I think
> we can drop this patch?
>
>

Depending how long they'll take, yes. This is meant to be an
intermediate correctness patch.
