Return-Path: <linux-kernel-owner+w=401wt.eu-S967340AbXFHC35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967340AbXFHC35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763753AbXFHC3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:29:48 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59510 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFHC3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:29:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=BaoH2aqKyRKMOLZtj//xc0jpiwBKzsWT4BJFuqahLRW6zJZmkBpzKTsSub6dWRido
	Ywss/QUrOvEe+SJ2Y69/Q==
Message-ID: <6599ad830706071928y17190565qdecba65efc18d60@mail.gmail.com>
Date: Thu, 7 Jun 2007 19:28:03 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: Per container statistics (containerstats)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       pj@sgi.com, cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
In-Reply-To: <4668BD18.7090603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606115813.GA32197@linux.vnet.ibm.com>
	 <20070607155445.edd5fded.akpm@linux-foundation.org>
	 <4668BD18.7090603@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > this needs tasklist_lock?
> >
>
> rcu_read_lock() should be fine. From Eric's patch at
>
> 2.6.17-mm2 - proc-remove-tasklist_lock-from-proc_pid_readdir.patch
>
> The patch mentions that "We don't need the tasklist_lock to safely
> iterate through processes anymore."

Containers V10 includes an iterator interface for listing the member
tasks of a container, which avoids scanning the entire tasklist.
Downside is that it currently requires taking a read_lock on a global
lock, but I hope to improve on that in the future.

Paul
