Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbYLVSt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbYLVSt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYLVStt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:49:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:24888 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbYLVStr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:49:47 -0500
Date: Mon, 22 Dec 2008 10:49:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH 04/26] kbuild: introduce $(kecho) convenience echo
Message-Id: <20081222104912.fca1d371.randy.dunlap@oracle.com>
In-Reply-To: <1229783497-19550-4-git-send-email-sam@ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
	<1229783497-19550-4-git-send-email-sam@ravnborg.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.494FE12B.00BE:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008 15:31:15 +0100 Sam Ravnborg wrote:

> From: Mike Frysinger <vapier@gentoo.org>
> 
> There is a bunch of places in the build system where we do 'echo' to show
> some nice status lines.  This means we still get output when running in
> silent mode.  So declare a new KECHO variable that only does 'echo' when we
> are in a suitable verbose build mode.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> [sam: added Documentation]
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Hi,
Just nits/clarifications (below).


> ---
>  Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
>  scripts/Kbuild.include             |    7 +++++++
>  2 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index 7a77533..51104f9 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -383,6 +383,20 @@ more details, with real examples.
>  	to prerequisites are referenced with $(src) (because they are not
>  	generated files).
>  
> +    $(kecho)
> +	echoing information to user in a rule is often a good practice

	                    to users

> +	but when execution "make -s" one does not expect to see any output

	         executing

> +	except for warnings/errors.
> +	To support this kbuild define $(kecho) which will echo out the

	                       defines

> +	text following $(kecho) to stdout except if "make -s" is used.

s/except if/unless/

> +
> +	Example:
> +		#arch/blackfin/boot/Makefile
> +		$(obj)/vmImage: $(obj)/vmlinux.gz
> +			$(call if_changed,uimage)
> +			@$(kecho) 'Kernel: $@ is ready'
> +
> +
>  --- 3.11 $(CC) support functions
>  
>  	The kernel may be built with several different versions of


---
~Randy
