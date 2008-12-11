Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYLKAxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYLKAxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 19:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYLKAxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 19:53:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:38960 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYLKAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 19:53:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=CRhx2f+1IKnRNs2RPFkn3BfrYTfXEqZFKqJvQZyRKakvPLStuNXTOd4rcOZ6LpYtC
	L0uNS5ALuMlRODa7i2mOw==
MIME-Version: 1.0
In-Reply-To: <20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081210233654.563182000@menage.corp.google.com>
	 <20081210234432.236302000@menage.corp.google.com>
	 <20081211094938.85b00cf3.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 10 Dec 2008 16:52:57 -0800
Message-ID: <6599ad830812101652o25bc33f3r2a710e0879f9b196@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/3] CGroups: Use hierarchy_mutex in memory 
	controller
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 4:49 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
>        an operation like rmdir() in somewhere.
>                hierarchy_lock for A (acquired)
>                hierarchy_lock for B (waiting)
>
>        in subsys A.
>                mmap_sem (acquired)
>                hierarchy_lock for A (waiting)
>        in subsys B.
>                hierarchy_lock for B (aquired)
>                mmap_sem             (waiting)
>

That's a valid deadlock - you'd need to require the mmap_sem nests
either inside all hierarchy_mutexes or else outside all of them.

Paul
