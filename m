Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYIKO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYIKO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbYIKO06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 10:26:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYIKO05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 10:26:57 -0400
Subject: Re: [PATCH 2/2] audit: Handle embedded NUL in TTY input auditing
From: Eric Paris <eparis@redhat.com>
To: Miloslav =?UTF-8?Q?Trma=C4=8D?= <mitr@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-audit <linux-audit@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1221085773.2705.25.camel@amilo>
References: <1221085773.2705.25.camel@amilo>
Content-Type: text/plain; charset=utf-8
Date: Thu, 11 Sep 2008 10:25:52 -0400
Message-Id: <1221143153.2992.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-11 at 00:29 +0200, Miloslav Trmač wrote:
> From: Miloslav Trmac <mitr@redhat.com>
> 
> Data read from a TTY can contain an embedded NUL byte (e.g. after
> pressing Ctrl-2, or sent to a PTY).  After the previous patch, the data
> would be logged only up to the first NUL.
> 
> This patch modifies the AUDIT_TTY record to always use the hexadecimal
> format, which does not terminate at the first NUL byte.  The vast
> majority of recorded TTY input data will contain either ' ' or '\n', so
> the hexadecimal format would have been used anyway.
> 
> Signed-off-by: Miloslav Trmac <mitr@redhat.com>

Acked-by: Eric Paris <eparis@redhat.com>

> ---
>  tty_audit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
> index 3582f43..5787249 100644
> --- a/drivers/char/tty_audit.c
> +++ b/drivers/char/tty_audit.c
> @@ -93,7 +93,7 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
>  		get_task_comm(name, tsk);
>  		audit_log_untrustedstring(ab, name);
>  		audit_log_format(ab, " data=");
> -		audit_log_n_untrustedstring(ab, buf->data, buf->valid);
> +		audit_log_n_hex(ab, buf->data, buf->valid);
>  		audit_log_end(ab);
>  	}
>  	buf->valid = 0;
> 
> 

