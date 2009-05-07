Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZEGQ3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZEGQ3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbZEGQ24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:28:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:17763 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbZEGQ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:28:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WiM+K3sobQleNJ+VnzZZyHJoHTPemt5qoHAd1cYVKAGTqm0iFCbkjvVmV9HFGYzlEM
         b/4A208/ECmtIIMG4W+qVnvXaCUIgFV8y5e6d1e6p9g+/+ha4On0PVqIGc7hvuruwiRc
         MFHIoCkRw7ToTVHteIz8jo+vjvM0SGnErHVnY=
Date: Thu, 7 May 2009 18:28:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/7] tracing: add hierarchical enabling of events
Message-ID: <20090507162849.GB5987@nowhere>
References: <20090507031335.815354104@goodmis.org> <20090507031434.807772092@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507031434.807772092@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:13:42PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> With the current event directory, you can only enable individual events.
> The file debugfs/tracing/set_event is used to be able to enable or
> disable several events at once. But that can still be awkward.
> 
> This patch adds hierarchical enabling of events. That is, each directory
> in debugfs/tracing/events has an "enable" file. This file can enable
> or disable all events within the directory and below.
> 
>  # echo 1 > /debugfs/tracing/events/enable
> 
> will enable all events.
> 
>  # echo 1 > /debugfs/tracing/events/sched/enable
> 
> will enable all events in the sched subsystem.
> 
>  # echo 1 > /debugfs/tracing/events/enable
>  # echo 0 > /debugfs/tracing/events/irq/enable
> 
> will enable all events, but then disable just the irq subsystem events.
> 
> When reading one of these enable files, there are four results:
> 
>  0 - all events this file affects are disabled
>  1 - all events this file affects are enabled
>  X - there is a mixture of events enabled and disabled
>  ? - this file does not affect any event



Nice, I also planned to support hierarchical events but I'm too
slow, thanks!

