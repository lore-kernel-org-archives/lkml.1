Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZBRJUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZBRJUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZBRJTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:19:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:55482 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZBRJTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:19:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,228,1233561600"; 
   d="scan'208";a="666474149"
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs
	users
From: Patrick Ohly <patrick.ohly@intel.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 10:19:30 +0100
Message-Id: <1234948770.23768.25.camel@ecld0pohly>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 19:52 +0200, Johannes Weiner wrote:
> Describe a setup that integrates better with Emacs' cc-mode and also
> fixes up the alignment of continuation lines to really only use tabs.
[...]
> +(defun c-lineup-arglist-tabs-only (ignored)
> +  "Line up argument lists by tabs, not spaces"
> +  (let* ((anchor (c-langelem-pos c-syntactic-element))
> +	 (column (c-langelem-2nd-pos c-syntactic-element))
> +	 (offset (- (1+ column) anchor))
> +	 (steps (floor offset c-basic-offset)))
> +    (* (max steps 1)
> +       c-basic-offset)))
>+
>+(add-hook 'c-mode-hook
> +          (lambda ()
> +            (let ((filename (buffer-file-name)))
> +              ;; Enable kernel mode for the appropriate files
> +              (when (and file
> +                         (string-match "/usr/src/linux" filename))
> +                (setq indent-tabs-mode t)
> +                (c-set-style "linux")
> +                (c-set-offset 'arglist-cont-nonempty
> +                              '(c-lineup-gcc-asm-reg
> +                                c-lineup-arglist-tabs-only))))))

When starting writing kernel source code last year (the hardware time
stamping patch) I used this macro to format it. I very much liked the
possibility to only switch on Linux style when editing Linux code
(because I work on a variety of code bases with different formatting).

But the macro above did not produce the result expected by some patch
reviewers (John Stultz, Dave Miller). I had to redo the formatting
manually.

The sticky point is continuation after splitting a long parameter list -
in other words, exactly what the "arglist-cont-nonempty" setting above
changes. The macro formats it so that the continuation is aligned at the
tab that is closest to the initial argument in the previous line:

int a_very_long_function_name(int arg1, char *arg2,
			double arg3);

The expected style was tab plus spaces to align with the first argument:

int a_very_long_function_name(int arg1, char *arg2,
			      double arg3);

Is this a bug in the macro? I'm using emacs 22.1.1, in case that
matters. Or are there different opinions in the Linux developer
community about the right formatting?

-- 
Best Regards, Patrick Ohly

The content of this message is my personal opinion only and although
I am an employee of Intel, the statements I make here in no way
represent Intel's position on the issue, nor am I authorized to speak
on behalf of Intel on this matter.

