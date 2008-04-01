Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYDAGGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYDAGGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 02:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYDAGG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 02:06:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6475 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYDAGGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 02:06:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KOpwHdkKHepyyur0MLEBB7k5ZzkgUrdyzSesb036VzlNRZhOSwKQgAaVIUxaq3rLh
	cZGw+9RudCJD/YtrFTEDw==
Message-ID: <6599ad830803312306l59fabaa0o2f62feb0d59b2ce3@mail.gmail.com>
Date: Mon, 31 Mar 2008 23:06:12 -0700
From: "Paul Menage" <menage@google.com>
To: "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v3)
Cc: balbir@linux.vnet.ibm.com, xemul@openvz.org, hugh@veritas.com,
       skumar@linux.vnet.ibm.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       rientjes@google.com, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <20080401060330.743815A02@siro.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401054324.829.4517.sendpatchset@localhost.localdomain>
	 <20080401060330.743815A02@siro.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:03 PM, YAMAMOTO Takashi
<yamamoto@valinux.co.jp> wrote:
>
>  changing mm->owner without notifying controllers makes it difficult to use.
>  can you provide a notification mechanism?
>

Yes, I think that call will need to be in the task_lock() critical
section in which we update mm->owner.

Right now I think the only user that needs to be notified at that
point is Balbir's virtual address limits controller.

Paul
