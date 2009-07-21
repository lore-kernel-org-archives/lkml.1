Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZGUPe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZGUPe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbZGUPe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:34:56 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62289 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZGUPe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:34:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=qG/8f0DpXaUHvpGIYp13S3UbYGAWAHr+kAowKTr0nSLsqu+RVMo1PiekpJB8wS0/3
	L76B73z8bIGofHzdy4Vtw==
MIME-Version: 1.0
In-Reply-To: <20090721120106.GW24157@balbir.in.ibm.com>
References: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
	 <20090721111019.GV24157@balbir.in.ibm.com>
	 <8522a3d30907210438u6fce081fi835bf964d0c01e8a@mail.gmail.com>
	 <20090721120106.GW24157@balbir.in.ibm.com>
Date: Tue, 21 Jul 2009 08:34:51 -0700
Message-ID: <6599ad830907210834y30e7d57aj978898a300a447d0@mail.gmail.com>
Subject: Re: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
From: Paul Menage <menage@google.com>
To: balbir@linux.vnet.ibm.com
Cc: Zefan Li <lizf.kernel@gmail.com>, Xiaotian Feng <dfeng@redhat.com>,
       lizf@cn.fujitsu.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 5:01 AM, Balbir Singh<balbir@linux.vnet.ibm.com> wrote:
>
> lock(A)
> lock(B)
> unlock(A)
> unlock(B)
>
> Tomorrow if a unsuspecting programmer does this
>
> lock(A)
> lock(B)
> unlock(A)
>
> code block
>
> unlock(B)
>
>
> What protects code block? lock B? Is that the intention?
>

An "unsuspecting programmer" shouldn't be adding code to
multi-threaded routines without thoroughly understanding the locking.

I guess there's no harm in this patch, but as Li says, it doesn't
really change anything.

Paul
