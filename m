Return-Path: <linux-kernel-owner+w=401wt.eu-S1750797AbZGNEEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797AbZGNEEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbZGNEEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:04:39 -0400
Received: from smtp-out.google.com ([216.239.45.13]:32629 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbZGNEEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:04:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Ny2yl89pyany381qItBiFddOoPHDazHA/ycB4eHOL32BVgfMre+X9119wA55oPYJ2
	s6B6mep0feFKSWWV6JvoQ==
MIME-Version: 1.0
In-Reply-To: <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	 <4A5AA3E7.9070800@cn.fujitsu.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
	 <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 13 Jul 2009 21:04:32 -0700
Message-ID: <6599ad830907132104o55d31ccexb15e5aa35c31416e@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Benjamin Blum <bblum@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 8:53 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> Hmm, ok...then, if too much pids, you hit vmalloc()/vfree() problem again.
> So, it's not good idea to use vmalloc/vfree here after all.
>

Agreed, using vmalloc()/vfree() isn't a perfect solution, but at least
the approach of kmalloc() for small allocations and vmalloc() for
larger allocations solves the current problem (reading tasks/procs
files can fail due to lack of contiguous kmalloc memory) without
introducing overhead in the typical case.

Paul
