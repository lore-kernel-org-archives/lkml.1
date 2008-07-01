Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYGAGlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYGAGlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYGAGlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:41:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32936 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbYGAGlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:41:36 -0400
Date: Tue, 1 Jul 2008 08:41:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH 21/24] kconfig: prefix hex values with 0x in .config
Message-ID: <20080701064122.GE16642@elte.hu>
References: <20080630213155.GA32479@uranus.ravnborg.org> <1214861718-32626-21-git-send-email-sam@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214861718-32626-21-git-send-email-sam@ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> We could hit a situation where hex values
> are stored internally in kconfig without 0x prefix, so if we see
> one of these add 0x prefix when we write value to .config.
> The real fix is to make sure we always prefix hex
> values with 0x in kconfig.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> ---
>  arch/x86/boot/compressed/relocs.c |    2 +-
>  scripts/kconfig/confdata.c        |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
> index edaadea..88d27f6 100644
> --- a/arch/x86/boot/compressed/relocs.c
> +++ b/arch/x86/boot/compressed/relocs.c
> @@ -244,7 +244,7 @@ static void read_ehdr(FILE *fp)
>  static void read_shdrs(FILE *fp)
>  {
>  	int i;
> -	if (ehdr.e_shnum > MAX_SHDRS) {
> +	if (1 || ehdr.e_shnum > MAX_SHDRS) {
>  		die("%d section headers supported: %d\n",
>  			ehdr.e_shnum, MAX_SHDRS);
>  	}

note: stale x86 change slipped into this patch, please do not commit it 
to the kbuild tree. (i suspect it happened when you sent me the 
MAX_SHDRS debug patch yesterday)

	Ingo
