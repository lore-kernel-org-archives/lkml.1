Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYISVj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYISVj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYISVjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:39:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbYISVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:39:48 -0400
Date: Fri, 19 Sep 2008 14:38:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: removed bogus newline
Message-Id: <20080919143847.0589646f.akpm@linux-foundation.org>
In-Reply-To: <20080919165146.0aa2ab80@psychotron.englab.brq.redhat.com>
References: <20080919165146.0aa2ab80@psychotron.englab.brq.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 16:51:46 +0200
Jiri Pirko <jpirko@redhat.com> wrote:

> Hi.
> 
> PATH records, as output by the kernel, contain a newline after the
> flags fields, which is in the middle of the record. EXECVE records
> contain a newline after every argument. auditd seems to hide this,
> but they're there nevertheless. If you're not using auditd, you
> need to work round them.
> 
> What do you think about it?
> 

It would be easier to understand your proposal if you were to include
before- and after- samples of the log record.


> 
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 59cedfb..bf10cb0 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1119,7 +1119,7 @@ static int audit_log_single_execve_arg(struct audit_context *context,
>  			audit_log_n_hex(*ab, buf, to_send);
>  		else
>  			audit_log_format(*ab, "\"%s\"", buf);
> -		audit_log_format(*ab, "\n");
> +		audit_log_format(*ab, " ");
>  
>  		p += to_send;
>  		len_left -= to_send;

Is no newline needed after this loop has terminated?
