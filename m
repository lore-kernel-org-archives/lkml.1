Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZIXR5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZIXR5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbZIXR5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:57:22 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:33753 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZIXR5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A8S+1Ogn2DjZMJzRKgn56aAWaHYOlRy7WWaWqAzPp4t15venVoHPMWqTJ/zxlVG6QP
         9yYHkuj1DlXyd3Rz5HwUMHr9hcEHvWTAvO0/gnrK0IirEuMavXdbWcfCEA4cZeqgAO5u
         AeWMCtBYHsrKFf8119INZX0UnZdSxYkbAMTxg=
Date: Thu, 24 Sep 2009 21:57:20 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v7][PATCH 0/9] Implement clone2() system call
Message-ID: <20090924175542.GA27678@x200>
References: <20090924165548.GA16586@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924165548.GA16586@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't like this even more.

Pid namespaces are hierarchical _and_ anonymous, so simply
set of numbers doesn't describe the final object.

struct pid isn't special, it's just another invariant if you like
as far as C/R is concerned, but system call is made special wrt pids.

What will be in an image? I hope "struct kstate_image_pid" with several
numbers and with references to such object from other places, so it
seems natural to do alloc_pid() with needed numbers and that attach new
shiny pid to where needed. But this clone_pid is only for task_struct's pids.
