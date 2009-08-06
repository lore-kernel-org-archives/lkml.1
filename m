Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbZHFOJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbZHFOJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZHFOJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:09:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:46545 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbZHFOJI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:09:08 -0400
Date: Thu, 6 Aug 2009 07:11:29 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ozan =?UTF-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] markup_oops: Use modinfo to avoid confusion with
 underscored module names
Message-ID: <20090806071129.3e5603ef@infradead.org>
In-Reply-To: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr>
References: <1249561315-2227-1-git-send-email-ozan@pardus.org.tr>
Organization: Intel
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Aug 2009 15:21:55 +0300
Ozan Çağlayan <ozan@pardus.org.tr> wrote:

> When EIP is at a module having an underscore in its name, the current
> code fails to find it because the module filenames has '-' instead of
> '_'.
> 
> Use modinfo to correctly get the full path to the module.
> 
> Signed-off-by: Ozan Çağlayan <ozan@pardus.org.tr>

I like it, it's simple.
I don't mind about the module-init-tools dependency, everyone will have
that already.

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Andrew: can you hover this one up and send to Linus when its time is
due?

> ---
> This is just a trivial patch to pinpoint the problem. Usage of
> modinfo is faster than searching through the filesystem but may not
> be desirable as it brings a dependency to module-init-tools.
> Replacing underscore occurences by '-' can be another solution.
> 
>  scripts/markup_oops.pl |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
> index 8977401..bc14f4c 100644
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -184,10 +184,7 @@ if ($target eq "0") {
>  
>  # if it's a module, we need to find the .ko file and calculate a
> load offset if ($module ne "") {
> -	my $dir = dirname($filename);
> -	$dir = $dir . "/";
> -	my $mod = $module . ".ko";
> -	my $modulefile = `find $dir -name $mod | head -1`;
> +	my $modulefile = `modinfo $module | grep 'filename' | gawk
> '{ print \$2 }'`; chomp($modulefile);
>  	$filename = $modulefile;
>  	if ($filename eq "") {


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
