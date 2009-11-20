Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZKTQqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZKTQqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 11:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZKTQqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 11:46:38 -0500
Received: from mail.atheros.com ([12.36.123.2]:40714 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZKTQqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 11:46:38 -0500
Date: Fri, 20 Nov 2009 08:46:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mcgrof@gmail.com" <mcgrof@gmail.com>
Subject: Re: [PATCH 2/4] kconfig: streamline_config.pl: fix out-of-tree
	builds
Message-ID: <20091120164633.GC13136@tux>
References: <1258732254-15573-1-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-2-git-send-email-alan-jenkins@tuffmail.co.uk> <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1258732254-15573-3-git-send-email-alan-jenkins@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 07:50:52AM -0800, Alan Jenkins wrote:
> We should look for Kconfig under $srctree, just like zconf.l does.
> This allows "make localmodconfig" to work when using a separate build
> directory (e.g. make O=../build).
> 
> Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> ---
>  scripts/kconfig/streamline_config.pl |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/streamline_config.pl b/scripts/kconfig/streamline_config.pl
> index 7d898e3..7a7bcf7 100644
> --- a/scripts/kconfig/streamline_config.pl
> +++ b/scripts/kconfig/streamline_config.pl
> @@ -46,7 +46,7 @@ use warnings;
>  #    make oldconfig
>  #
>  my $config = ".config";
> -my $linuxpath = ".";
> +my $srctree = $ENV{"srctree"} || ".";
> 
>  my $uname = `uname -r`;
>  chomp $uname;
> @@ -114,7 +114,7 @@ sub find_config {
> 
>  find_config;
> 
> -my @makefiles = `find $linuxpath -name Makefile`;
> +my @makefiles = `find $srctree -name Makefile`;
>  my %depends;
>  my %selects;
>  my %prompts;
> @@ -135,7 +135,11 @@ sub read_kconfig {
>      my $config;
>      my @kconfigs;
> 
> -    open(KIN, $kconfig) || die "Can't open $kconfig";
> +    open(KIN, $kconfig) || (
> +       $kconfig =~ "^[^/]" &&
> +       open(KIN, $srctree . "/" . $kconfig)
> +    ) || die "Can't open $kconfig";
> +

God I hate perl, can this be a little perl-un-obfuscated a bit?

  Luis
