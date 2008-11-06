Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbYKFHQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbYKFHQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:16:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbYKFHP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:15:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbYKFHP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:15:56 -0500
Date: Thu, 6 Nov 2008 08:14:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] Revert "x86: default to reboot via ACPI"
Message-ID: <20081106071445.GI15731@elte.hu>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com> <1225915018-6548-16-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225915018-6548-16-git-send-email-ehabkost@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduardo Habkost <ehabkost@redhat.com> wrote:

> This reverts commit c7ffa6c26277b403920e2255d10df849bd613380.
> 
> Now that we have the hooks to disable virtualization on
> emergency_restart(), we can get back to the BOOT_KBD reboot_type default.
> 
> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>

hm, why revert this? There's nothing wrong with the ACPI reboot 
method, it's just that we surprise the BIOS by exiting with an unclean 
VMX state in certain circumstances.

if the ACPI reboot method does not work we do the KBD method as the 
next thing in the reboot chain.

	Ingo
