Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbZGMPZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbZGMPZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756145AbZGMPZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:25:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48378 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbZGMPZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:25:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=wpW0ch5IWLxVXHveF08rktL7LK+1N/teYn6UsrFaGo8TwHcc0nl6ruEBCQa9BQ4wC
	jamBSldsRebwG3Z/82yTQ==
MIME-Version: 1.0
In-Reply-To: <4A5AAE02.7060106@cn.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230154.16778.58053.stgit@hastromil.mtv.corp.google.com>
	 <4A5AAE02.7060106@cn.fujitsu.com>
Date: Mon, 13 Jul 2009 11:25:24 -0400
Message-ID: <2f86c2480907130825x7189c713la2f5bd99749926@mail.gmail.com>
Subject: Re: [PATCH 1/3] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com, menage@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 12, 2009 at 11:46 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> I think a better demonstration is:
>
>  $ cat tasks
>  1000
>  1001
>  1002
>
>  $ cat procs
>  1000

Indeed.

>> +     /*
>> +      * if the length difference is large enough, we want to allocate a
>> +      * smaller buffer to save memory. if this fails due to out of memory,
>> +      * we'll just stay with what we've got.
>> +      */
>> +     if (PIDLIST_REALLOC_DIFFERENCE(length, dest)) {
>> +             newlist = kmalloc(dest * sizeof(pid_t), GFP_KERNEL);
>
> krealloc()
>

Ah yes. I had thought about krealloc and determined that it wasn't
clever enough to do in-place resizing, but forgot that it could be
used anyway here.
