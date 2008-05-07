Return-Path: <linux-kernel-owner+w=401wt.eu-S1759212AbYEGDiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212AbYEGDiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYEGDh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:37:58 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYEGDh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:37:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xFKSafrvIL/nnUptmXbfuypBAooD9Tqn8ySHK6TPDBiu/a6FwKXxFgHWdsT01ebMX
	JW1cEwi+343/RCwVti4LA==
Message-ID: <6599ad830805062037n221ef8e2n9ee7ac33417ab499@mail.gmail.com>
Date: Tue, 6 May 2008 20:37:50 -0700
From: "Paul Menage" <menage@google.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: on CONFIG_MM_OWNER=y, kernel panic is possible.
Cc: balbir@linux.vnet.ibm.com, "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080506153943.AC69.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080506151510.AC66.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <481FFAAB.3030008@linux.vnet.ibm.com>
	 <20080506153943.AC69.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2008 at 11:43 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> > >  #ifdef CONFIG_MM_OWNER
>  > > -       struct task_struct *owner;      /* The thread group leader that */
>  > > -                                       /* owns the mm_struct.          */
>  > > +       struct task_struct *owner;      /* point to one of task that owns the mm_struct. */
>  > >  #endif
>  > >
>  > >  #ifdef CONFIG_PROC_FS
>  >
>  > How about just, the task that owns the mm_struct? One of, implies multiple owners.
>
>  Ah, below is better?
>
>  /* point to any one of task that related the mm_struct. */

I'd word it as

/*
 * "owner" points to a task that is regarded as the canonical
 * user/owner of this mm. All of the following must be true in
 * order for it to be changed:
 *
 * current == mm->owner
 * current->mm != mm
 * new_owner->mm == mm
 * new_owner->alloc_lock is held
 */

Paul
