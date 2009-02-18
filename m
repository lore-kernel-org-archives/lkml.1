Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbZBRJ5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbZBRJ5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 04:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZBRJ5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 04:57:33 -0500
Received: from cmpxchg.org ([85.214.51.133]:49866 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZBRJ5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 04:57:32 -0500
Date: Wed, 18 Feb 2009 10:59:31 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Patrick Ohly <patrick.ohly@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] documentation: update CodingStyle tips for Emacs users
Message-ID: <20090218095931.GA2054@cmpxchg.org>
References: <87tzf5tu3z.fsf@skyscraper.fehenstaub.lan> <1234948770.23768.25.camel@ecld0pohly>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234948770.23768.25.camel@ecld0pohly>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 10:19:30AM +0100, Patrick Ohly wrote:
> On Fri, 2008-07-04 at 19:52 +0200, Johannes Weiner wrote:
> > Describe a setup that integrates better with Emacs' cc-mode and also
> > fixes up the alignment of continuation lines to really only use tabs.
> [...]
> > +(defun c-lineup-arglist-tabs-only (ignored)
> > +  "Line up argument lists by tabs, not spaces"
> > +  (let* ((anchor (c-langelem-pos c-syntactic-element))
> > +	 (column (c-langelem-2nd-pos c-syntactic-element))
> > +	 (offset (- (1+ column) anchor))
> > +	 (steps (floor offset c-basic-offset)))
> > +    (* (max steps 1)
> > +       c-basic-offset)))
> >+
> >+(add-hook 'c-mode-hook
> > +          (lambda ()
> > +            (let ((filename (buffer-file-name)))
> > +              ;; Enable kernel mode for the appropriate files
> > +              (when (and file
> > +                         (string-match "/usr/src/linux" filename))
> > +                (setq indent-tabs-mode t)
> > +                (c-set-style "linux")
> > +                (c-set-offset 'arglist-cont-nonempty
> > +                              '(c-lineup-gcc-asm-reg
> > +                                c-lineup-arglist-tabs-only))))))
> 
> When starting writing kernel source code last year (the hardware time
> stamping patch) I used this macro to format it. I very much liked the
> possibility to only switch on Linux style when editing Linux code
> (because I work on a variety of code bases with different formatting).
> 
> But the macro above did not produce the result expected by some patch
> reviewers (John Stultz, Dave Miller). I had to redo the formatting
> manually.
> 
> The sticky point is continuation after splitting a long parameter list -
> in other words, exactly what the "arglist-cont-nonempty" setting above
> changes. The macro formats it so that the continuation is aligned at the
> tab that is closest to the initial argument in the previous line:
> 
> int a_very_long_function_name(int arg1, char *arg2,
> 			double arg3);
> 
> The expected style was tab plus spaces to align with the first argument:
> 
> int a_very_long_function_name(int arg1, char *arg2,
> 			        double arg3);
> 
> Is this a bug in the macro? I'm using emacs 22.1.1, in case that
> matters. Or are there different opinions in the Linux developer
> community about the right formatting?

Unfortunately, this seems to depend on the maintainer.  Both styles
are used all over the kernel but Documentation/CodingStyle and
scripts/checkpatch.pl prefer what the above emacs configuration does.

I doubt that people do tab tab tab space space space space space by
hand, so I strongly suspect that the tab-only zealots don't use emacs
which does this adjustment automatically.

You should probably add linux-davem to the above or something.  Or
name the coding style after the text-editor the target maintainer
uses :-)

	Hannes
