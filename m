Return-Path: <linux-kernel-owner+w=401wt.eu-S934344AbZD3R7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbZD3R7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 13:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762846AbZD3Ruw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 13:50:52 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:59433 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933966AbZD3Ruu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 13:50:50 -0400
Date: Thu, 30 Apr 2009 19:52:59 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, jdb@comx.dk,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build of bzImage with 64 bit compiler
Message-ID: <20090430175259.GA9894@uranus.ravnborg.org>
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org> <49F9BB47.7080806@zytor.com> <20090430150924.GA8656@uranus.ravnborg.org> <49F9D1E5.2090805@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F9D1E5.2090805@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 09:29:25AM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >>>
> >> I'm wondering if we should build the *.lds.S with -ansi or some other
> >> gcc option which disables ALL non-underscore macros.
> > 
> > I did not know that -ansi had this effect.
> > We are only seldomly hitting this issue and I wonder
> > if it could break something in out included headers.
> > Most likely not.
> > 
> 
> The other thing to recognize is probably that lds files aren't assembly,
> they're something else entirely.  Rather than reusing the *.S rules,
> having specific rules for them probably would make sense.

We already have that:
(scripts/Makfile.build)
# Linker scripts preprocessor (.lds.S -> .lds)
# ---------------------------------------------------------------------------
quiet_cmd_cpp_lds_S = LDS     $@
      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<

$(obj)/%.lds: $(src)/%.lds.S FORCE
        $(call if_changed_dep,cpp_lds_S)


So adding -ansi is trivial and will only hit .lds.S files.

I assume the lds files are named .S is because we shared rules
long time ago.

	Sam
