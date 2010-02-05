Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab0BEVjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:39:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:40288 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab0BEVjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:39:03 -0500
Message-ID: <4B6C8FF0.3090106@suse.cz>
Date: Fri, 05 Feb 2010 22:38:56 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hui Zhu <hui.zhu@windriver.com>
Cc: =?UTF-8?B?QW3DqXJpY28gV2FuZw==?= <xiyou.wangcong@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Sam Ravnborg <sam@ravnborg.org>, ozan@pardus.org.tr,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org,
       teawater@gmail.com
Subject: Re: [PATCH] markup_oops.pl: add options to improve cross-sompilation
  environments
References: <4B5E5D4F.50803@windriver.com>	 <2375c9f91001251905p6ed99405m3915ac56e230605f@mail.gmail.com>	 <4B5E9BE9.2030702@windriver.com> <2375c9f91001252353u52f437b0t7ddd643a57047e1c@mail.gmail.com> <4B5EB223.60307@windriver.com> <4B6344CA.10504@suse.cz> <4B666982.1020007@windriver.com>
In-Reply-To: <4B666982.1020007@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.2.2010 06:41, Hui Zhu wrote:
> I make a patch according to your mail.
> 
> Best regards,
> Hui
> 
> 1. Fix a little format issue.
> 2. Check the return of "Getopt::Long::GetOptions".  Output usage and
> exit if it get error.
> 3. Change $ARGV[$#ARGV] to $ARGV[0].
> 4. Change the code which get $modulefile from modinfo.  Replace the
> pipeline with `modinfo -F filename $module`.
> 4. Change usage from "Specify the module directory name" to "Specify the
> module filename".
> 
> Signed-off-by: Hui Zhu <teawater@gmail.com>

Thanks, I applied the previous and this patch. Just to make sure I
didn't miss any of your patches, can you check that
http://repo.or.cz/w/linux-kbuild.git/blob/refs/heads/for-next:/scripts/markup_oops.pl
has all your changes? If something is missing, please resend it, thanks.

Michal

> ---
> scripts/markup_oops.pl |   10 +++++-----
> 1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/scripts/markup_oops.pl
> +++ b/scripts/markup_oops.pl
> @@ -23,10 +23,10 @@ my $modulefile = "";
> # Get options
> Getopt::Long::GetOptions(
>     'cross-compile|c=s'    => \$cross_compile,
> -    'module|m=s'    => \$modulefile,
> +    'module|m=s'        => \$modulefile,
>     'help|h'        => \&usage,
> -);
> -my $vmlinux_name = $ARGV[$#ARGV];
> +) || usage ();
> +my $vmlinux_name = $ARGV[0];
> if (!defined($vmlinux_name)) {
>     my $kerver = `uname -r`;
>     chomp($kerver);
> @@ -193,7 +193,7 @@ if ($target eq "0") {
> # if it's a module, we need to find the .ko file and calculate a load
> offset
> if ($module ne "") {
>     if ($modulefile eq "") {
> -        my $modulefile = `modinfo $module | grep '^filename:' | awk '{
> print \$2 }'`;
> +        $modulefile = `modinfo -F filename $module`;
>         chomp($modulefile);
>     }
>     $filename = $modulefile;
> @@ -361,7 +361,7 @@ Usage:
> 
> OPTION:
>   -c, --cross-compile CROSS_COMPILE    Specify the prefix used for
> toolchain.
> -  -m, --module MODULE_DIRNAME        Specify the module directory name.
> +  -m, --module MODULE_DIRNAME        Specify the module filename.
>   -h, --help                Help.
> EOT
>     exit;
> 
> 

