Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYKEPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYKEPFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 10:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbYKEPFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 10:05:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52380 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbYKEPFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 10:05:43 -0500
Date: Wed, 5 Nov 2008 13:04:55 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Haren Myneni <hbabu@us.ibm.com>, Andrey Borzenkov <arvidjaar@mail.ru>,
       mingo@redhat.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] x86: disable virt on kdump and emergency_restart
Message-ID: <20081105150454.GG5247@blackpad>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com> <49107E2C.8090803@redhat.com> <20081105144412.GD8993@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105144412.GD8993@redhat.com>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 09:44:12AM -0500, Vivek Goyal wrote:
> On Tue, Nov 04, 2008 at 06:54:04PM +0200, Avi Kivity wrote:
> > Eduardo Habkost wrote:
> >> Hi,
> >>
> >> This is a new version of the series to disabling virtualization on kdump,
> >> now extended to do the same tricks on emergency_restart() if needed.
> >>   
> >
> > Looks good.  If you me to push it upstream, I'll need kexec/kdump acks.   
> > Otherwise, ack for the kvm bits.
> 
> Looks good to me from kdump perspective.
> 
> Is there a way we can prevent any other module from using virt disable
> callback incase kvm is not loaded?

I think we can't prevent other modules from using the API. But 3rd-party
modules deal with CPU virtualization extensions today won't live with
KVM today, anyway. And between not living together with KVM and breaking
kdump/reboot, and not living together with KVM and making kdump and
reboot working, I the the latter looks better.

But I see this as an orthogonal issue. If we include a "CPU virtualization
extensions core API" in the future, it could simply keep the same
emergency_virt_disable() API available for emergency_restart and kdump.

-- 
Eduardo
