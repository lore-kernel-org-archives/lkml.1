Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXJIXf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXJIXf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbXJIXfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:35:17 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10473 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbXJIXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:35:15 -0400
Date: Tue, 9 Oct 2007 16:28:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of
 depends
Message-Id: <20071009162812.00e80a0c.randy.dunlap@oracle.com>
In-Reply-To: <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au>
	<Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 09:19:55 +1000 (EST) James Morris wrote:

> From: Eric Paris <eparis@redhat.com>
> 
> Changes the security/selinux/Kconfig to use select instead of depends
> for most of the SELinux requirements.  This allows the SELinux option to
> show up when people do a make config without already knowing they had to
> enable audit and other non-obvious choices.  Added a depends on SECURITY
> (which previously existed through SECURITY_NETWORK) so that SELinux
> would not always show up, but would be easy and intuitive to find.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: James Morris <jmorris@e.namei>
> ---
>  security/selinux/Kconfig |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
> index b32a459..40b97e6 100644
> --- a/security/selinux/Kconfig
> +++ b/security/selinux/Kconfig
> @@ -1,6 +1,10 @@
>  config SECURITY_SELINUX
>  	bool "NSA SELinux Support"
> -	depends on SECURITY_NETWORK && AUDIT && NET && INET
> +	depends on SECURITY
> +	select SECURITY_NETWORK
> +	select AUDIT
> +	select NET
> +	select INET
>  	select NETWORK_SECMARK
>  	default n
>  	help

I doth protest.  Enabling the entire NET subsystem thru a hidden
select is awful.  Select should be used (sparingly) to enable
library code only.  If someone wants NET enabled, they should
enable it overtly, not covertly.


> @@ -9,6 +13,7 @@ config SECURITY_SELINUX
>  	  You can obtain the policy compiler (checkpolicy), the utility for
>  	  labeling filesystems (setfiles), and an example policy configuration
>  	  from <http://www.nsa.gov/selinux/>.
> +
>  	  If you are unsure how to answer this question, answer N.
>  
>  config SECURITY_SELINUX_BOOTPARAM



---
~Randy
