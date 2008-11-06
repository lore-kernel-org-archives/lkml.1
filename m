Return-Path: <linux-kernel-owner+w=401wt.eu-S1754278AbYKFMlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbYKFMlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 07:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYKFMlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 07:41:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44821 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbYKFMla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 07:41:30 -0500
Date: Thu, 6 Nov 2008 10:40:31 -0200
From: Eduardo Habkost <ehabkost@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081106124031.GO5247@blackpad>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <1225915018-6548-16-git-send-email-ehabkost@redhat.com> <20081106071445.GI15731@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106071445.GI15731@elte.hu>
X-Fnord: you can see the fnord
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 08:14:45AM +0100, Ingo Molnar wrote:
> 
> * Eduardo Habkost <ehabkost@redhat.com> wrote:
> 
> > This reverts commit c7ffa6c26277b403920e2255d10df849bd613380.
> > 
> > Now that we have the hooks to disable virtualization on
> > emergency_restart(), we can get back to the BOOT_KBD reboot_type default.
> > 
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> 
> hm, why revert this? There's nothing wrong with the ACPI reboot 
> method, it's just that we surprise the BIOS by exiting with an unclean 
> VMX state in certain circumstances.
> 
> if the ACPI reboot method does not work we do the KBD method as the 
> next thing in the reboot chain.

I suppose there are cases where the new default broke without KVM, and
the suggestion was to disable VMX before rebooting instead of changing
the default.

Avi changed the default because on some machines reboot=kbd breaks when
VMX is enabled, but the regressions caused by the new default doesn't
necessarily involve VMX.

Andrey Borzenkov's patch, for example, adds a new DMI entry because
reboot=acpi breaks his keyboard (even without KVM, I guess). Andrey,
was that the case?

-- 
Eduardo
