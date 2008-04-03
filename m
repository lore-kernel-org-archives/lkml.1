Return-Path: <linux-kernel-owner+w=401wt.eu-S1758031AbYDCXtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031AbYDCXtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYDCXti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:49:38 -0400
Received: from smtp-out.google.com ([216.239.33.17]:23301 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYDCXth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:49:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=C0aKp7ynF94i/Sk1Ydex/wxoHpjgZ2pwLeoDuPkfSmZRNcmGNArMeoPJXzL3AOssp
	S14G+Gc3lnA5+UPQcqLBA==
Message-ID: <6599ad830804031649p6bbc60f3s59fb7c25a7260505@mail.gmail.com>
Date: Thu, 3 Apr 2008 16:49:24 -0700
From: "Paul Menage" <menage@google.com>
To: matthltc@us.ibm.com
Subject: Re: [Devel] [RFC PATCH 0/4] Container Freezer: Reuse Suspend Freezer
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <20080403210316.397506379@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403210316.397506379@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 2:03 PM,  <matthltc@us.ibm.com> wrote:
>
>    * "freezer.kill"
>
>      writing <n> will send signal number <n> to all tasks
>

My first thought (not having looked at the code yet) is that sending a
signal doesn't really have anything to do with freezing, so it
shouldn't be in the same subsystem. Maybe a separate subsystem called
"signal"?

And more than that, it's not something that requires any particular
per-process state, so there's no reason that the subsystem that
provides the "kill" functionality shouldn't be able to be mounted in
multiple hierarchies.

How about if I added support for stateless subsystems, that could
potentially be mounted in multiple hierarchies at once? They wouldn't
need an entry in the css set, since they have no state.

>  * Usage :
>
>    # mkdir /containers/freezer
>    # mount -t container -ofreezer freezer  /containers/freezer
>    # mkdir /containers/freezer/0
>    # echo $some_pid > /containers/freezer/0/tasks
>
>  to get status of the freezer subsystem :
>
>    # cat /containers/freezer/0/freezer.freeze
>    RUNNING
>
>  to freeze all tasks in the container :
>
>    # echo 1 > /containers/freezer/0/freezer.freeze
>    # cat /containers/freezer/0/freezer.freeze
>    FREEZING
>    # cat /containers/freezer/0/freezer.freeze
>    FROZEN

Could we separate this out into two files? One called "freeze" that's
a 0/1 for whether we're intending to freeze the subsystem, and one
called "frozen" that indicates whether it is frozen? And maybe a
"state" file to report the RUNNING/FREEZING/FROZEN distinction in a
human-readable way?

Paul
