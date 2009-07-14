Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZGNBoE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZGNBoE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 21:44:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZGNBoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 21:44:03 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZGNBoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 21:44:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com>
References: <20090708095616.cdfe8c7c.kamezawa.hiroyu@jp.fujitsu.com> <6599ad830907131515h3c9622b5v309cf8f13d272bab@mail.gmail.com>
Message-Id: <20090714100440.6283.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 14 Jul 2009 10:43:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jul 7, 2009 at 5:56 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > I know people likes to wait for file descriptor to get notification in these days.
> > Can't we have "event" file descriptor in cgroup layer and make it reusable for
> > other purposes ?
> 
> I agree - rather than having to add a separate "wait for value to
> cross X threshold" file for each numeric usage value that people might
> be concerned about, it would be better to have a generic way to do it
> for any file. Given that this is a userspace API, it would be better
> to work out at least the generic API first, even if the initial
> implementation isn't generic.
> 
> Properties that it should support include:
> 
> - notification when a value crosses above or below a given threshold
> (which would include binary cases such as OOM notification where the
> value cross from "not-OOM" to "OOM"
> 
> - independent thresholds for different waiters
>
> - epoll support (by using eventfd?)

signalfd?


> - automatic wakeup when a cgroup is removed
> 
> - maybe optional wakeup when a thread attach occurs?
> 
> - not require more than read permissions on the file containing the
> value being monitored
> 
> I guess there are a few possible ways this could be exposed to userspace:
> 
> 1) new ioctl on cgroups files. simple but probably not popular
> 
> 2) new system call. maybe the cleanest, but involves changing every
> arch and is hard to script
> 
> 3) new per-cgroup file to control these e.g:
>   - create an eventfd
>   - open the control file to be monitored
>   - write the "<event_fd>, <control_fd> <threshold> to
> cgroup.event_control to link them together
> flexible and scriptable but maybe a clumsy interface in general

I like multiple threshold and per-thresold file-descriptor.
it solve multiple waiters issue. 

but How about this?

  /cgroup
    /group1
      /notifications
         /threashold-A
         /threashold-B






