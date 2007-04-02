Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXDBFxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXDBFxx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXDBFxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:53:52 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36665 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932796AbXDBFxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:53:52 -0400
Date: Sun, 1 Apr 2007 22:53:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 11/16] samba-eintr-fix.diff
Message-Id: <20070401225337.42c23578.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012009230.12316@yvahk01.tjqt.qr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:16:22 +0200 (MEST) Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> From: Dave Jones
> Already posted at http://lkml.org/lkml/2005/7/7/255
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> Cc: Dave Jones <Dave Jones <davej@redhat.com>
> 
>  request.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.21-rc5/fs/smbfs/request.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/fs/smbfs/request.c
> +++ linux-2.6.21-rc5/fs/smbfs/request.c
> @@ -347,6 +347,7 @@ int smb_add_request(struct smb_request *
>  			smb_rput(req);
>  		}
>  		smb_unlock_server(server);
> +		return -EINTR;
>  	}
>  
>  	if (!timeleft) {
> #<EOF>

This can return -EINTR if timeleft == 0 && !signal_pending(), which seems
wrong.

