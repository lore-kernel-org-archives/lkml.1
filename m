Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbZAZPUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbZAZPUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAZPUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:20:07 -0500
Received: from mta-out.inet.fi ([195.156.147.13]:47785 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZAZPUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:20:06 -0500
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH] Documentation: update CodingStyle tips for Emacs users
In-Reply-To: <1232299115-8130-1-git-send-email-tlikonen@iki.fi> (Teemu Likonen's message of "Sun\, 18 Jan 2009 19\:18\:35 +0200")
References: <1232299115-8130-1-git-send-email-tlikonen@iki.fi>
From: Teemu Likonen <tlikonen@iki.fi>
Date: Mon, 26 Jan 2009 17:20:02 +0200
Message-ID: <87priaumal.fsf@iki.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Teemu Likonen (2009-01-18 19:18 +0200) wrote:

> With the previous Emacs tips example the kernel style was made available
> for files in the kernel-tree only. This patch updates the tip to add
> separate cc-mode indent style; it makes the kernel style easily
> available for any filetype mode that is managed by the Emacs cc-mode.
>
> We also fix the filename regexp in the example: Elisp function
> buffer-file-name returns full pathname, not a path relative to user's
> home directory. Hence a tilde (~) can't be used to refer to home
> directory (as the previous code did).
>
> Signed-off-by: Teemu Likonen <tlikonen@iki.fi>
> ---
>  Documentation/CodingStyle |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)


Exactly what I expected: nobody pays any attention. :-) Well, it's not a
problem, I'm not even a kernel coder. I just happen to think that this
patch introduces the right way to configure Emacs for kernel coding
style. Adding a custom style like this ("linux-tabs-only") makes it much
easier to switch between different indent styles and also to use the
kernel style elsewhere.

So, I'll just ping the lists and maintainers this one more time to see
if someone is interested. Here's my original message:

    http://article.gmane.org/gmane.linux.documentation/442


> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 1875e50..2cda242 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -483,20 +483,27 @@ values.  To do the latter, you can stick the following in your .emacs file:
>      (* (max steps 1)
>         c-basic-offset)))
>  
> +(add-hook 'c-mode-common-hook
> +          (lambda ()
> +            ;; Add kernel style
> +            (c-add-style
> +             "linux-tabs-only"
> +             '("linux" (c-offsets-alist
> +                        (arglist-cont-nonempty
> +                         c-lineup-gcc-asm-reg
> +                         c-lineup-arglist-tabs-only))))))
> +
>  (add-hook 'c-mode-hook
>            (lambda ()
>              (let ((filename (buffer-file-name)))
>                ;; Enable kernel mode for the appropriate files
>                (when (and filename
> -                         (string-match "~/src/linux-trees" filename))
> +                         (string-match "src/linux-trees" filename))
>                  (setq indent-tabs-mode t)
> -                (c-set-style "linux")
> -                (c-set-offset 'arglist-cont-nonempty
> -                              '(c-lineup-gcc-asm-reg
> -                                c-lineup-arglist-tabs-only))))))
> +                (c-set-style "linux-tabs-only")))))
>  
>  This will make emacs go better with the kernel coding style for C
> -files below ~/src/linux-trees.
> +files which pathname matches src/linux-trees.
>  
>  But even if you fail in getting emacs to do sane formatting, not
>  everything is lost: use "indent".
> -- 
> 1.6.1.156.gb648d
