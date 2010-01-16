Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0APS3g (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 13:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990Ab0APS3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 13:29:35 -0500
Received: from mail.tmr.com ([64.65.253.246]:37536 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824Ab0APS3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 13:29:34 -0500
Message-ID: <4B520571.7050502@tmr.com>
Date: Sat, 16 Jan 2010 13:29:05 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Xiantao Zhang <xiantao.zhang@intel.com>, kvm-ia64@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: remove redundant NULL tests
References: <4B4F4EF6.2050202@gmail.com>
In-Reply-To: <4B4F4EF6.2050202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> kvm_get_exit_data() cannot return a NULL pointer.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/ia64/kvm/kvm_fw.c |   28 +++++++++++++---------------
>  1 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
> index e4b8231..cb548ee 100644
> --- a/arch/ia64/kvm/kvm_fw.c
> +++ b/arch/ia64/kvm/kvm_fw.c
> @@ -75,7 +75,7 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
>  	struct exit_ctl_data *p;
>  
>  	p = kvm_get_exit_data(vcpu);
> -	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
> +	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
>  		p->u.pal_data.ret = result;
>  		return ;
>  	}
	[___etc___]

Clearly the original author thought that there was a path where kvm_exit_data 
could return a NULL pointer, was that ever possible?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
