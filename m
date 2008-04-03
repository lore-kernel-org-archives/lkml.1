Return-Path: <linux-kernel-owner+w=401wt.eu-S1757580AbYDCR6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580AbYDCR6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDCR60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:58:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYDCR6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:58:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=m3lExa6Y5Lfl1lj0OZ0e4z5WnBP8085MlwVEz3uQyx4D3Nb3Ytcybog8DvKTJyc+T
	JR31EhyulfHgUofE3A6dw==
Message-ID: <6599ad830804031058l1e2a7ad9p56cff47dca738d79@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:58:20 -0700
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [-mm] Add an owner to the mm_struct (v7)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403174433.26356.42121.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 10:44 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  +
>  +       /*
>  +        * If there are other users of the mm and the owner (us) is exiting
>  +        * we need to find a new owner to take on the responsibility.
>  +        * When we use thread groups (CLONE_THREAD), the thread group
>  +        * leader is kept around in zombie state, even after it exits.
>  +        * delay_group_leader() ensures that if the group leader is around
>  +        * we need not select a new owner.
>  +        */

Hmm, is this new check for delay_group_leader() safe? Won't we have
called exit_cgroup() by this point, and hence be reassigned to the
root cgroup? And so mm->owner->cgroups won't point to the right place?

Paul
