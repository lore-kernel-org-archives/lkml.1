Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZK0EWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZK0EWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZK0EWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:22:42 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37783 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbZK0EWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:22:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=VdhRxff+ZtIZEUGl3sV+K7VlnMNFc8Pl5glb3aqyKH5UbU+J8BPvL+XTzxtM+P9Be/
         jYSUeHUSX6PPlGH1U6THD4M6enF3ylPRimf4ZxqIU3O0TZmGBxs2D7bUdaoXs4N1uCKs
         2BS9mGieF6K5p9YVbQHLCl5YNPM3cBhMnjMqA=
Date: Fri, 27 Nov 2009 05:22:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Anton Blanchard <anton@samba.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, msb@google.com
Subject: Re: PATCH: softlockup: Fix hung_task_check_count sysctl
Message-ID: <20091127042245.GB5221@nowhere>
References: <20091127022820.GU32182@kryten> <2375c9f90911261846i18a828eft391420b13bb3fbb2@mail.gmail.com> <20091127025512.GB5406@nowhere> <2375c9f90911261902q1f7df666nc0b303e89d88d643@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2375c9f90911261902q1f7df666nc0b303e89d88d643@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 11:02:13AM +0800, Américo Wang wrote:
> On Fri, Nov 27, 2009 at 10:55 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> > On Fri, Nov 27, 2009 at 10:46:53AM +0800, Américo Wang wrote:
> >> On Fri, Nov 27, 2009 at 10:28 AM, Anton Blanchard <anton@samba.org> wrote:
> >> >
> >> > I'm seeing spikes of up to 0.5ms in khungtaskd on a large machine. To reduce
> >> > this source of jitter I tried setting hung_task_check_count to 0:
> >> >
> >> > # echo 0 > /proc/sys/kernel/hung_task_check_count
> >> >
> >> > which didn't have the intended response. Change to a post increment of
> >> > max_count, so a value of 0 means check 0 tasks.
> >> >
> >> > Signed-off-by: Anton Blanchard <anton@samba.org>
> >>
> >>
> >> Ack.
> >>
> >> I would also suggest to make 'max_count' as unsigned long,
> >> since sysctl_hung_task_check_count is.
> >>
> >> Thanks.
> >
> >
> > Also, the batch_count thing should be dropped I think.
> > This is a hardcoded, not overridable pause after 1024
> > threads checks to avoid latencies caused by rcu_read_lock.
> > But now we have PREEMPT_RCU so people can enable it if
> > they care about latency. We should remove it as it adds
> > unnecessary complexity.
> 
> This sounds OK for me.
> 
> >
> > I'm preparing a patch for that, on top of Anton patch.
> >
> 
> Great!
> 
> Thanks.


Actually it looks like this check is not only there to take
care of latency but also to avoid too much waiting before
a grace period.

Hm, well, I'm not sure what to do.

