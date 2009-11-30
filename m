Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbZK3Jyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbZK3Jyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 04:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZK3Jyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 04:54:31 -0500
Received: from smtp.iptel.org ([213.192.59.67]:58315 "EHLO mail.iptel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbZK3Jyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 04:54:31 -0500
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 04:54:30 EST
Date: Mon, 30 Nov 2009 10:49:30 +0100
From: Andrei Pelinescu-Onciul <andrei@iptel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
Message-ID: <20091130094929.GY10897@shell.iptel.org>
References: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 30, 2009 at 16:40, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
> 
> Today's linux-next build (x86_64 allmodconfig) produced this warning:
> 
> net/sctp/socket.c: In function 'sctp_setsockopt_autoclose':
> net/sctp/socket.c:2091: warning: large integer implicitly truncated to unsigned type
> 
> Introduced by commit f6778aab6ccc4b510b4dcfa770d9949b696b4545 ("sctp:
> limit maximum autoclose setsockopt value") from the net tree.

Thanks, the fix is:

-               sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
+               sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;

I'll reply to this mail with the patch in git format.

Andrei
