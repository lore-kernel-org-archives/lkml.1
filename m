Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYJLLMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYJLLMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 07:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYJLLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 07:12:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60689 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYJLLMh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 07:12:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] cifs: fix build on !CONFIG_KEYS
Date: Sun, 12 Oct 2008 13:17:06 +0200
User-Agent: KMail/1.9.9
Cc: Steve French <sfrench@us.ibm.com>, Jeff Layton <jlayton@redhat.com>,
       linux-kernel@vger.kernel.org
References: <20081012110904.GA581@elte.hu>
In-Reply-To: <20081012110904.GA581@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810121317.07372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 12 of October 2008, Ingo Molnar wrote:
> 
> hi,
> 
> find a quick build fix for CIFS below - you might have it already. 
> Please double-check.

Heh, I've just sent another fix for the same issue. :-)

Thanks,
Rafael

 
> ----------->
> From 9d65371d47bc0285a557f279d402764f73551d3c Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 12 Oct 2008 13:01:52 +0200
> Subject: [PATCH] cifs: fix build on !CONFIG_KEYS
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> CIFS has keys infrastructure dependencies:
> 
>   fs/cifs/sess.c: In function ‘CIFS_SessSetup’:
>   fs/cifs/sess.c:628: error: implicit declaration of function ‘key_revoke’
> 
> So express that dependency in the Kconfig.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  fs/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 40183d9..c0eade5 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -1876,6 +1876,7 @@ config SMB_NLS_REMOTE
>  config CIFS
>  	tristate "CIFS support (advanced network filesystem, SMBFS successor)"
>  	depends on INET
> +	depends on KEYS
>  	select NLS
>  	help
>  	  This is the client VFS module for the Common Internet File System
