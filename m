Return-Path: <linux-kernel-owner+w=401wt.eu-S1764218AbZLQJb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764218AbZLQJb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764193AbZLQJbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:31:55 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:32922 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764189AbZLQJbw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FDoqLz2y83OeOrgEV7I5VSpaMqkSsb2bSt4Pfv4+U+OmNBpqzc2F5t5GMDgZcz6Dp1
         yiMZfUq7+F+d+2m4H9rk4tuUqyQyC4LeqKA4iGMeLa5gdoGPbMABOekjSa1AmtuNKWC9
         5jzDFVOZQSFdYzMLLXjLG1yTaDSOBpGfN1I5s=
MIME-Version: 1.0
In-Reply-To: <200912152326.34728.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912152326.34728.bzolnier@gmail.com>
Date: Thu, 17 Dec 2009 17:31:51 +0800
Message-ID: <2375c9f90912170131g3144ca2eydfa067c85f6ced44@mail.gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 6:26 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Tuesday 15 December 2009 10:57:49 pm Mikulas Patocka wrote:
>
>> But some maintainers take output of the script checkpatch.pl dogmatically,
>> requiring that every new work must pass the script without a warning. This is
>> counterproductive --- if I write a driver and I will be doing most maintenance
>> work on it in the future, it is viable that the driver is formatted in such
>> a way that is best editable for me, not for anyone else. And as shown in example
>> (1), this 80-column requirement makes even simple changes much harder.
>
> It has been agreed in the past that 80-column warnings shouldn't result
> automatically in the rejection of the new hardware support so the above
> argumentation is a bit weak.
>
>> So: I am submitting this patch for the checkpatch.pl script.
>>
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> Having this limitation makes people at least think about designing their
> code properly and making it more compact.
>
> If you don't want to see such warnings just apply the following patch that
> I've been keeping locally (it helped me to work on staging drivers):
>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] checkpatch.pl: add option to disable 80 column limit check
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


I like this patch, this is actually what I wanted to do.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!

> ---
>  scripts/checkpatch.pl |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> Index: b/scripts/checkpatch.pl
> ===================================================================
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -17,6 +17,7 @@ use Getopt::Long qw(:config no_auto_abbr
>  my $quiet = 0;
>  my $tree = 1;
>  my $chk_signoff = 1;
> +my $chk_cl = 1;
>  my $chk_patch = 1;
>  my $tst_only;
>  my $emacs = 0;
> @@ -41,6 +42,7 @@ Options:
>   -q, --quiet                quiet
>   --no-tree                  run without a kernel tree
>   --no-signoff               do not check for 'Signed-off-by' line
> +  --no-cl                    do not apply 80 column limit
>   --patch                    treat FILE as patchfile (default)
>   --emacs                    emacs compile window format
>   --terse                    one line per report
> @@ -67,6 +69,7 @@ GetOptions(
>        'q|quiet+'      => \$quiet,
>        'tree!'         => \$tree,
>        'signoff!'      => \$chk_signoff,
> +       'cl!'           => \$chk_cl,
>        'patch!'        => \$chk_patch,
>        'emacs!'        => \$emacs,
>        'terse!'        => \$terse,
> @@ -1365,7 +1368,7 @@ sub process {
>                next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
>
>  #80 column limit
> -               if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
> +               if ($chk_cl && $line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
>                    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
>                    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
>                    $length > 80)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
