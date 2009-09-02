Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZIBGyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZIBGyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 02:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZIBGyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 02:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZIBGyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 02:54:39 -0400
Message-ID: <4A9E16AD.8080508@redhat.com>
Date: Wed, 02 Sep 2009 08:54:37 +0200
From: Chris Lalancette <clalance@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH 2/2] add sysctl for kvm wallclock sync
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <1251805848-17451-3-git-send-email-glommer@redhat.com>
In-Reply-To: <1251805848-17451-3-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index fc409e9..3a4e1bd 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -27,7 +27,7 @@
>  #define KVM_SCALE 22
>  
>  static int kvmclock = 1;
> -static unsigned int kvm_wall_update_interval = 5;
> +unsigned int kvm_wall_update_interval = 5;

I think the overall idea is very interesting, but I also think that it should be
disabled by default.  Because of the problems with time in virtualization,
people are already conditioned to run ntpd inside their guests, and this
kvmclock change will "fight" with ntpd.  Also, the command "# date 09091323" (or
whatever) ceases to work like it does on bare-metal, so I think it has to be an
opt-in feature.

-- 
Chris Lalancette
