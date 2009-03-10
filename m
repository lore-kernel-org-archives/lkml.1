Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbZCJKRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbZCJKRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 06:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZCJKRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 06:17:01 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:56212 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbZCJKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 06:17:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BLfKZP93bNgj/KkS5ukCLfk1j0SbyxeZPyXB9KPiFqIMKI2UjqFpoCZgTDpau2ab+g
         YlTWc5VxrFH475I8hSBUEA7omDhBoBxGTRq+yehhun2zwtZUOqQ1B8Euw5PfZ+xLF7hh
         UcqsGdW6P8LQDWgzEmpbfkNByfD1ELPl4IRzQ=
Date: Tue, 10 Mar 2009 13:23:55 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stoyan Gaydarov <stoyboyker@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 03/25] [net] BUG to BUG_ON changes
Message-ID: <20090310102355.GB2248@x200.localdomain>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com> <1236661850-8237-2-git-send-email-stoyboyker@gmail.com> <1236661850-8237-3-git-send-email-stoyboyker@gmail.com> <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 12:10:28AM -0500, Stoyan Gaydarov wrote:
> --- a/drivers/net/pppol2tp.c
> +++ b/drivers/net/pppol2tp.c
> @@ -1222,8 +1222,7 @@ static void pppol2tp_tunnel_closeall(struct pppol2tp_tunnel *tunnel)
>  	struct pppol2tp_session *session;
>  	struct sock *sk;
>  
> -	if (tunnel == NULL)
> -		BUG();
> +	BUG_ON(tunnel == NULL);

NAK, should be deleted, and kernel will oops anyway.

>  	PRINTK(tunnel->debug, PPPOL2TP_MSG_CONTROL, KERN_INFO,
>  	       "%s: closing all sessions...\n", tunnel->name);
