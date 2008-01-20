Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbYATBjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbYATBjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 20:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYATBjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 20:39:41 -0500
Received: from saeurebad.de ([85.214.36.134]:53178 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYATBjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 20:39:40 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: David Brown <lkml@davidb.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update emacs indentation instructions.
References: <1200783192-24399-1-git-send-email-lkml@davidb.org>
Date: Sun, 20 Jan 2008 02:40:29 +0100
In-Reply-To: <1200783192-24399-1-git-send-email-lkml@davidb.org> (David
	Brown's message of "Sat, 19 Jan 2008 14:53:12 -0800")
Message-ID: <87fxwt5l6a.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

David Brown <lkml@davidb.org> writes:

> +Fortunately, modern versions of GNU emacs support different indentation
> +styles.  If you want to use the Linux kernel style for all C code, place
> +the following in your .emacs file:
> +
> +(setq c-default-style "linux")

This variable is not defined when emacs starts up.  Best is to always
use a hook.

So I'd suggest either

	(add-hook 'c-mode-hook (lambda () (c-set-style "linux")))

or for the conditional case

	(add-hook 'c-mode-hook
                  (lambda ()
                    (c-set-style
                      (or (and (string-match "/usr/src/linux"
                                             (or (buffer-file-name) ""))
                               "linux")
                          "free-group-style"))))

Perhaps the logic could be a bit more readable :-)

Other than that, good idea to finally remove this ugly recommendation!

	Hannes
