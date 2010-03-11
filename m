Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0CKNu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 08:50:27 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37060 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab0CKNu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 08:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AdBL0gwV23wI0urJOj3+aOP0BNzjcNjZjh0hUKjHGImjRnFk24R1OgnVjR+HNvlszh
         mzIt5Ou6SVOG3o8DQVgFu5OdnCzsRwaXWkpvhx95gKIyC+37tRNJ7i1OaWUIHsPsDLFd
         Kwdco6P+oes1Gs3730OuvuTjLB6i6KwHKphHk=
MIME-Version: 1.0
In-Reply-To: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
References: <1268312220-12880-1-git-send-email-jkacur@redhat.com>
Date: Thu, 11 Mar 2010 14:50:22 +0100
X-Google-Sender-Auth: 2021895561586796
Message-ID: <520f0cf11003110550v3ba245c1v6dc1c7511251ab66@mail.gmail.com>
Subject: Re: [PATCH] perf: Make the install relative to DESTDIR if specified
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Kyle McMartin <kyle@redhat.com>,
       John Kacur <jkacur@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 1:57 PM, John Kacur <jkacur@redhat.com> wrote:
> Without this change, the install path is relative to
> prefix/DESTDIR
> where prefix is automatically set to $HOME
>
> This can produce unexpected results. For example
>
> make -C tools/perf DESTDIR=/home/jkacur/tmp install-man
>
> creates the directory:          /home/jkacur/home/jkacur/tmp/share/...
> instead of  the expected:       /home/jkacur/tmp/share/...
>
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  tools/perf/Documentation/Makefile |    4 +++-
>  tools/perf/Makefile               |    4 +++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
> index bdd3b7e..bd498d4 100644
> --- a/tools/perf/Documentation/Makefile
> +++ b/tools/perf/Documentation/Makefile
> @@ -24,7 +24,10 @@ DOC_MAN1=$(patsubst %.txt,%.1,$(MAN1_TXT))
>  DOC_MAN5=$(patsubst %.txt,%.5,$(MAN5_TXT))
>  DOC_MAN7=$(patsubst %.txt,%.7,$(MAN7_TXT))
>
> +# Make the path relative to DESTDIR, not prefix
> +ifndef DESTDIR
>  prefix?=$(HOME)
> +endif
>  bindir?=$(prefix)/bin
>  htmldir?=$(prefix)/share/doc/perf-doc
>  pdfdir?=$(prefix)/share/doc/perf-doc
> @@ -32,7 +35,6 @@ mandir?=$(prefix)/share/man
>  man1dir=$(mandir)/man1
>  man5dir=$(mandir)/man5
>  man7dir=$(mandir)/man7
> -# DESTDIR=
>
>  ASCIIDOC=asciidoc
>  ASCIIDOC_EXTRA = --unsafe
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 2d53738..5da0cd0 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -216,7 +216,10 @@ STRIP ?= strip
>  # runtime figures out where they are based on the path to the executable.
>  # This can help installing the suite in a relocatable way.
>
> +# Make the path relative to DESTDIR, not to prefix
> +ifndef DESTDIR
>  prefix = $(HOME)
> +endif
>  bindir_relative = bin
>  bindir = $(prefix)/$(bindir_relative)
>  mandir = share/man
> @@ -233,7 +236,6 @@ sysconfdir = $(prefix)/etc
>  ETC_PERFCONFIG = etc/perfconfig
>  endif
>  lib = lib
> -# DESTDIR=
>
>  export prefix bindir sharedir sysconfdir
>
> --
> 1.6.6.1

Sorry, I'd like to withdraw this patch.

I see I can achieve my desired ends without changing the behaviour for
others who expect the old behaviour,
simply by setting "prefix" on the command line, eg:
make -C tools/perf prefix="" DESTDIR=/home/jkacur/tmp install-man

Thanks.
