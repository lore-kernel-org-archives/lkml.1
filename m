Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbYCXQKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbYCXQKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYCXQKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:10:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58567 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbYCXQKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:10:11 -0400
Date: Mon, 24 Mar 2008 09:09:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH] kbuild: silence documentation GEN xml messages
 according to $(quiet)
Message-Id: <20080324090939.73f8b00b.randy.dunlap@oracle.com>
In-Reply-To: <1206371815-32376-1-git-send-email-vapier@gentoo.org>
References: <1206371815-32376-1-git-send-email-vapier@gentoo.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Mar 2008 11:16:55 -0400 Mike Frysinger wrote:

> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  Documentation/DocBook/Makefile |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 300e170..f6a4ba3 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -186,8 +186,11 @@ quiet_cmd_fig2png = FIG2PNG $@
>  
>  ###
>  # Rule to convert a .c file to inline XML documentation
> +       gen_xml = :
> + quiet_gen_xml = echo '  GEN     $@'
> +silent_gen_xml = :
>  %.xml: %.c
> -	@echo '  GEN     $@'
> +	@$($(quiet)gen_xml)
>  	@(                            \
>  	   echo "<programlisting>";   \
>  	   expand --tabs=8 < $< |     \
> -- 

The Makefile changes are good, but the patch description makes it
appear that Mike was rushed.  How about something like this?

Add rules for gen_xml and its quiet & silent variants.
This causes "make -s" to be silent for gen_xml.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
